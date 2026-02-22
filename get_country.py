import asyncio
from sqlalchemy import text
from sqlalchemy.ext.asyncio import create_async_engine
import sys
import os

# Ensure app imports work
sys.path.append(os.path.join(os.getcwd(), "backend"))
from app.core.database import DATABASE_URL

async def run():
    engine = create_async_engine(DATABASE_URL)
    async with engine.connect() as conn:
        res = await conn.execute(text('SELECT id FROM "Country" LIMIT 1'))
        country_id = res.scalar()
        print(country_id)
    await engine.dispose()

if __name__ == "__main__":
    asyncio.run(run())
