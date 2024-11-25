import re;

class UserInputValidation:
  """
  Class used to validate user input such as usernames, passwords, and emails.
  """

  @staticmethod
  def validate_password(password: str) -> bool:
    """
    Validates a password based on strength requirements.
    - At least 8 characters long.
    - Contains at least one uppercase letter, one lowercase letter, one number, and one special character.
    """
    if len(password) < 8:
      return False

    if not re.search(r"[A-Z]", password):  # At least one uppercase letter
      return False

    if not re.search(r"[a-z]", password):  # At least one lowercase letter
      return False

    if not re.search(r"\d", password):  # At least one digit
      return False

    if not re.search(r"[!@#$%^&*(),.?\":{}|<>]", password):  # At least one special character
      return False

    return True

  @staticmethod
  def validate_email(email: str) -> bool:
    """
    Validates an email address format.
    """
    email_regex = r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"
    return re.match(email_regex, email) is not None

  @staticmethod
  def validate_username(username: str) -> bool:
    """
    Validates a username.
    - Must be between 3 and 20 characters.
    - Can contain alphanumeric characters, underscores, and hyphens.
    - Must start with a letter.
    """
    username_regex = r"^[a-zA-Z][a-zA-Z0-9_-]{2,19}$"
    return re.match(username_regex, username) is not None
