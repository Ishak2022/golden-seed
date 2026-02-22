import asyncio
import httpx
import os
import sys

# Define base URL
BASE_URL = "http://localhost:8000/api/v1"

async def main():
    async with httpx.AsyncClient(timeout=30.0) as client:
        print("Checking root...")
        try:
            r = await client.get("http://localhost:8000/")
            print(f"Root status: {r.status_code}")
        except Exception as e:
            print(f"Root check failed: {e}")

        print("Starting Verification Flow...")
        try:
            # Register Admin using Bootstrap Token
            print("Registering new Admin...")
            suffix = "test" + os.urandom(2).hex()
            admin_email = f"admin_{suffix}@funtravelo.com"
            admin_password = "AdminPass123!"
            
            # Try to read bootstrap token from env or default
            bootstrap_token = os.environ.get("BOOTSTRAP_TOKEN", "golden-seed-audit-2026") # Updated default to match audit script
            
            # Admin registration
            r_adm_reg = await client.post(f"{BASE_URL}/auth/register", json={
                "email": admin_email,
                "password": admin_password,
                "full_name": "Test Admin",
                "role": "PLATFORM_ADMIN"
            }, headers={"X-Bootstrap-Token": bootstrap_token})
            print(f"Admin Reg status: {r_adm_reg.status_code}")
            
            if r_adm_reg.status_code != 200:
                 print(f"Admin Reg failed: {r_adm_reg.text}")
                 return

            # Login Admin
            r_admin = await client.post(f"{BASE_URL}/auth/login", data={"username": admin_email, "password": admin_password})
            if r_admin.status_code != 200:
                print(f"Admin login failed: {r_admin.status_code} {r_admin.text}")
                return
                
            admin_token = r_admin.json()["access_token"]
            print("Admin logged in.")
            admin_headers = {"Authorization": f"Bearer {admin_token}"}
            
            # Create Solo Agency
            print("Creating Solo Agency...")
            agency_data = {
                "name": f"Solo {suffix}",
                "domain": f"solo.{suffix}",
                "plan": "GROWTH",
                "owner_id": r_adm_reg.json()["user_id"]
            }
            
            r_agency = await client.post(f"{BASE_URL}/agencies", json=agency_data, headers=admin_headers)
            print(f"Agency Create status: {r_agency.status_code}")
            if r_agency.status_code != 201:
                print(f"Agency Create failed: {r_agency.text}")
                return
                
            agency_id = r_agency.json()["id"]
            print(f"Agency created: {agency_id}")
            
            # Register User linked to Agency
            print(f"Registering user for agency {agency_id}...")
            user_email = f"user_{suffix}@solo.com"
            user_password = "UserPass123!"
            
            r_reg = await client.post(f"{BASE_URL}/auth/register", json={
                "email": user_email,
                "password": user_password,
                "full_name": "Test User",
                "role": "AGENCY_OWNER",
                "agency_id": agency_id
            })
            print(f"User Reg status: {r_reg.status_code}")
            
            if r_reg.status_code == 200:
                user_id = r_reg.json()["user_id"]
                # Login User
                r_login = await client.post(f"{BASE_URL}/auth/login", data={"username": user_email, "password": user_password})
                print(f"User Login status: {r_login.status_code}")
                
                if r_login.status_code == 200:
                    token = r_login.json()["access_token"]
                    print("Got User token.")
                    
                    # Create Booking
                    print("Creating booking...")
                    booking_data = {
                        "pnr_locator": "ABCDEF",
                        "guest_name": "John Doe",
                        "guest_email": "guest@example.com",
                        "total_price": 1000.0,
                        "wholesale_cost": 800.0,
                        "margin": 200.0,
                        "currency": "USD"
                    }
                    r_booking = await client.post(
                        f"{BASE_URL}/agencies/{agency_id}/bookings",
                        json=booking_data,
                        headers={"Authorization": f"Bearer {token}"}
                    )
                    print(f"Booking status: {r_booking.status_code}")
                    print(f"Booking body: {r_booking.text}")
                else:
                     print(f"User Login failed: {r_login.text}")
            else:
                print(f"User Reg failed: {r_reg.text}")

        except Exception as e:
            print(f"Error during verification: {e}")

if __name__ == "__main__":
    asyncio.run(main())
