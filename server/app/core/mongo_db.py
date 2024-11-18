from os import getenv;
from dotenv import load_dotenv;

import pymongo;
import pymongo.database;
from pymongo.server_api import ServerApi;
from pymongo.errors import PyMongoError;

class MongoDB:
  """
  MongoDatabase class that makes it easy to connect and disconnect from the database.
  
  Attributes:
    database_url (str) : Database URL used to connect to the database
    database_client (pymongo.MongoClient) : pymongo Client
    database (pymongo.database.Database) : pymongo Database
  """
  database_url : str;
  database_client : pymongo.MongoClient | None;
  database : pymongo.database.Database | None;
  
  def __init__(self) -> None:
    """
    initializes the database attributes
    
    Parameters
      self : object class instance

    Returns
      None

    Raises
      None
    """
    # get the env variables
    load_dotenv("server/app/.env");
    self.database_url = getenv("DATABASE_URL");
  
  def establishConnection(self) -> None:
    """
    establishes a connection to the main database
    
    Parameters
      self : object class instance

    Returns
      None

    Raises
      None
    """
    # open a connection to the database;
    self.database_client = pymongo.MongoClient(self.database_url, server_api=ServerApi('1'));
    self.database = self.database_client["MealGen"];

  def closeConnection(self) -> None:
    """
    closes any existing connection to the main database
    
    Parameters
      self : object class instance

    Returns
      None

    Raises
      None
    """
    
    # closes the database connections;
    if self.database_client is not None:
      self.database_client.close()
      self.database_client = None;
      self.database = None;

