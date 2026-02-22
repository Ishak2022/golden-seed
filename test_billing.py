
import asyncio
import httpx
import sys
import os
import uuid
import json
import time
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine

# Ensure app imports work
start_dir = os.getcwd()
sys.path.append(os.path.join(start_dir, "backend"))
from app.core.database import DATABASE_URL, SessionLocal
from app.services.financial_ops import FinancialOpsService

BASE_URL = "http://localhost:8000/api/v1"
ADMIN_EMAIL = f"test_bill_{uuid.uuid4().hex[:6]}@funtravelo.com"
ADMIN_PASS = "TestPass123!"
BOOTSTRAP_TOKEN = "golden-seed-audit-2026"

async def run():
    async with httpx.AsyncClient(base_url=BASE_URL, timeout=30.0) as client:
        # 1. Auth & Setup
        res = await client.post("/auth/register", json={"email": ADMIN_EMAIL, "password": ADMIN_PASS, "full_name": "Bill Admin", "role": "PLATFORM_ADMIN"}, headers={"X-Bootstrap-Token": BOOTSTRAP_TOKEN})
        login_res = await client.post("/auth/login", data={"username": ADMIN_EMAIL, "password": ADMIN_PASS})
        token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        solo_res = await client.post("/agencies", json={"name": "Bill Ag", "domain": f"bill.{uuid.uuid4().hex[:4]}", "plan": "GROWTH", "owner_id": res.json()["user_id"]}, headers=headers)
        solo_id = solo_res.json()["id"]
        
        # Register Agency Owner for Billing (Ensures Account Link)
        bill_email = f"user_bill_{uuid.uuid4().hex[:4]}@solo.com"
        await client.post("/auth/register", json={"email": bill_email, "password": ADMIN_PASS, "full_name": "Bill User", "role": "AGENCY_OWNER", "agency_id": solo_id})
        login_res = await client.post("/auth/login", data={"username": bill_email, "password": ADMIN_PASS})
        token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        # Get Account ID
        engine = create_async_engine(DATABASE_URL)
        async with engine.connect() as conn:
             q_acc = await conn.execute(text(f"SELECT account_id FROM \"Agency\" WHERE id = '{solo_id}'"))
             bill_acc_id = q_acc.scalar()
             month_key = time.strftime("%Y-%m")
             
             # SEED
             print(f"Seeding usage to 2998 for {bill_acc_id}...")
             await conn.execute(text(f"DELETE FROM \"UsageCounter\" WHERE account_id = '{bill_acc_id}' AND month_key = '{month_key}'"))
             await conn.execute(text(f"INSERT INTO \"UsageCounter\" (id, account_id, month_key, calls_used, updated_at) VALUES ('test_bill_{solo_id}', '{bill_acc_id}', '{month_key}', 2998, NOW())"))
             await conn.commit()
             
        # Traffic (5 calls)
        print("Sending 5 requests...")
        for i in range(5):
            r = await client.get(f"/agencies/{solo_id}/golden-seeds?limit=1", headers=headers)
            if r.status_code != 200:
                print(f"Req {i} failed: {r.status_code}")
                
        # Trigger Service
        print("Triggering Overage Calc...")
        async with SessionLocal() as db:
            service = FinancialOpsService(tenant_id=solo_id, http_client=None)
            res = await service.calculate_monthly_overage(db, bill_acc_id, month_key)
            print(f"Service Result: {res}")
            
        # Verify
        async with engine.connect() as conn:
            cnt = (await conn.execute(text(f"SELECT calls_used FROM \"UsageCounter\" WHERE account_id = '{bill_acc_id}' AND month_key = '{month_key}'"))).scalar()
            evts = (await conn.execute(text(f"SELECT amount_cents FROM \"BillingEvent\" WHERE account_id = '{bill_acc_id}'"))).fetchall()
            
            print(f"Final Usage: {cnt}")
            print(f"Billing Events: {evts}")
            
            if cnt == 3003 and len(evts) > 0 and evts[0][0] == 3:
                print("PASS: Billing Verified (2998->3003, $0.03)")
            else:
                print("FAIL: Billing Mismatch")

if __name__ == "__main__":
    asyncio.run(run())
