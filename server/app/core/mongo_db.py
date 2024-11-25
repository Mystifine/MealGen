import pymongo;
import pymongo.database;
from pymongo.server_api import ServerApi;
from pymongo.errors import PyMongoError;

from .settings import Settings;

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

    self.database_url = Settings.MONGO_DB_URL;
  
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
    # Attempts to establish a database client
    try:
      self.database_client = pymongo.MongoClient(self.database_url, server_api=ServerApi('1'));
      self.database = self.database_client["MealGen"];
    except PyMongoError as e:
      print(f"An error occurred: {e}");

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
    
    # Closes the database connection.
    try:
      if self.database_client is not None:
        self.database_client.close()
        self.database_client = None;
        self.database = None;
    except PyMongoError as e:
      print(f"An error occurred while closing the database connection: {e}");
