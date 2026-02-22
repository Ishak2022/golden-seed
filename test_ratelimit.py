
import asyncio
import httpx
import sys
import os
import uuid
from collections import Counter

# Ensure we can import 
start_dir = os.getcwd()
sys.path.append(os.path.join(start_dir, "backend"))

BASE_URL = "http://localhost:8000/api/v1"
ADMIN_EMAIL = f"test_rl_{uuid.uuid4().hex[:6]}@funtravelo.com"
ADMIN_PASS = "TestPass123!"
BOOTSTRAP_TOKEN = "golden-seed-audit-2026"

async def run():
    async with httpx.AsyncClient(base_url=BASE_URL, timeout=30.0, limits=httpx.Limits(max_keepalive_connections=20, max_connections=200)) as client:
        # 1. Auth
        print("Registering Admin...")
        res = await client.post("/auth/register", json={"email": ADMIN_EMAIL, "password": ADMIN_PASS, "full_name": "RL Admin", "role": "PLATFORM_ADMIN"}, headers={"X-Bootstrap-Token": BOOTSTRAP_TOKEN})
        if res.status_code != 200:
            print(f"Admin Reg Failed: {res.text}")
            return
        
        login_res = await client.post("/auth/login", data={"username": ADMIN_EMAIL, "password": ADMIN_PASS})
        token = login_res.json()["access_token"]
        headers = {"Authorization": f"Bearer {token}"}
        
        # 2. Setup Agency
        print("Creating Agency...")
        solo_res = await client.post("/agencies", json={"name": "RL Ag", "domain": f"rl.{uuid.uuid4().hex[:4]}", "plan": "GROWTH", "owner_id": res.json()["user_id"]}, headers=headers)
        solo_id = solo_res.json()["id"]
        
        # 3. Burst
        print("Bursting 120 requests...")
        async def fetch(i):
            return await client.get(f"/agencies/{solo_id}/golden-seeds?limit=1", headers=headers)
            
        tasks = [fetch(i) for i in range(120)]
        responses = await asyncio.gather(*tasks, return_exceptions=True)
        
        codes = []
        for r in responses:
            if isinstance(r, Exception):
                codes.append(500)
            else:
                codes.append(r.status_code)
                
        c = Counter(codes)
        print(f"Results: {dict(c)}")
        
        if c.get(429, 0) > 0:
            print("PASS: Rate Limit Triggered")
        else:
            print("FAIL: No 429")

if __name__ == "__main__":
    asyncio.run(run())
