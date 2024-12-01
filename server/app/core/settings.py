import os;

from dotenv import load_dotenv;

class Settings:
  """
  Holds application settings/configs.
  
  Attributes:
    FLASK_ENV (str) : Flask environment
    FLASK_SECRET_KEY (str): Flask secret key
    
    MONGO_DB_URL (str) : URL used to connect to MongoDB
    
    JWT_SECRET_KEY (str) : JWT secret key for authentication generation.
  """
  FLASK_ENV = None;
  FLASK_SECRET_KEY = None;
  FLASK_PORT_NUMBER = None;

  MONGO_DB_URL = None;
  
  JWT_SECRET_KEY = None;

  @staticmethod
  def loadSettings():
    """
    Calls load_dotenv and loads all settings for the application.
    """
    
    # load the env variables
    current_file_path = os.path.dirname(__file__);
    
    project_folder_path = os.path.dirname(os.path.dirname(os.path.dirname(current_file_path)));
    
    env_path = os.path.join(project_folder_path, 'server', 'app', '.env');
    
    if not load_dotenv(env_path):
      print('FAILED TO GET ENVIRONMENT VARIABLES PLEASE TRY AGAIN.');
      return;

    Settings.FLASK_ENV = os.getenv("FLASK_ENV");
    Settings.FLASK_SECRET_KEY = os.getenv("FLASK_SECRET_KEY");
    Settings.FLASK_PORT_NUMBER = os.getenv("FLASK_PORT_NUMBER");
    
    Settings.MONGO_DB_URL = os.getenv("MONGO_DB_URL");
    
    Settings.JWT_SECRET_KEY = os.getenv('JWT_SECRET_KEY');
    
    # validate setting in the end.
    Settings.validateSettings(); 
    
  @staticmethod
  def validateSettings():
    """
    Validate essential settings to ensure the application can run properly.
    """
    if not Settings.FLASK_SECRET_KEY:
      raise ValueError("FLASK_SECRET_KEY is missing. Please set it in the environment variables.")
    if not Settings.FLASK_PORT_NUMBER:
      raise ValueError("FLASK_PORT_NUMBER is missing. Please set it in the environment variables.")
    if not Settings.MONGO_DB_URL:
      raise ValueError("MONGO_DB_URL is missing. Please set it in the environment variables.")
    if not Settings.JWT_SECRET_KEY:
      raise ValueError("JWT_SECRET_KEY is missing. Please set it in the environment variables.")