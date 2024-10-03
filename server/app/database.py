
from dotenv import load_dotenv;

import os

class Database:
    database_url : str;
    
    def __init__(self) -> None:
      load_dotenv("server/app/.env");
      self.database_url = os.getenv("DATABASE_URL");
      
    def main(self) -> None:
      pass;

