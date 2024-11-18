import jwt;
from datetime import datetime, timedelta;

class Authentication:
  """
  Authentication class for authentication functions
  
  Attributes:
    secret_key (str) : secret key to sign the generated codes
  """
  
  secret_key = "u84FOHTfbOBewmLHomgtvGckVpfTiJzTmwAsqO_ngNg"
  
  @staticmethod
  def generateAuthenticationToken(user_id : str) -> str:
    """
    generates and returns an authentication code provided a userid.
    
    Parameters:
      user_id
      
    Returns:
      str: The authentication generated code
    """
    payload = {
      "user_id" : user_id,
      "exp": datetime.now() + timedelta(hours=10)
    }
    authentication_token = jwt.encode(payload, Authentication.secret_key, algorithm='HS256');
    return authentication_token;
    
  @staticmethod
  def validateAuthenticationToken(token : str) -> dict[str : str] | str:
    """
    Validates authentication token
    
    Args:
      token (str): The token to be authenticated

    Returns:
      dict[str : str] | str: The payload of the token or an error message.
    """
    try:
      payload = jwt.decode(token, Authentication.secret_key, algorithms=["HS256"]);
      return payload;  
    except jwt.ExpiredSignatureError:
      return "Token has expired";
    except jwt.InvalidTokenError:
      return "Invalid token";