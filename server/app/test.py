from dotenv import load_dotenv
import os

# Load .env file
load_dotenv("server/app/.env")

# Retrieve environment variables
flask_env = os.getenv("FLASK_ENV")
secret_key = os.getenv("SECRET_KEY")
database_url = os.getenv("DATABASE_URL")

# Debugging: print environment variables
print(f"FLASK_ENV: {flask_env}")
print(f"SECRET_KEY: {secret_key}")
print(f"DATABASE_URL: {database_url}")