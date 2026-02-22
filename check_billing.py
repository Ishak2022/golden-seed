
import sys
import os
sys.path.append(os.path.join(os.getcwd(), 'backend'))

import asyncio
from sqlalchemy import text
from app.core.database import DATABASE_URL
from sqlalchemy.ext.asyncio import create_async_engine

async def check():
    engine = create_async_engine(DATABASE_URL)
    async with engine.connect() as conn:
        r = await conn.execute(text('SELECT * FROM "BillingEvent" ORDER BY timestamp DESC LIMIT 1'))
        rows = r.fetchall()
        print(f"Latest Billing Event: {rows}")
        if rows:
            print(f"Timestamp: {rows[0].timestamp}")
            print(f"Amount: {rows[0].amount_cents}")

if __name__ == "__main__":
    asyncio.run(check())
