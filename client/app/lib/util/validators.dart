//**
// Validation properties should match that of the server for consistency.
// */

class Validators {
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 20;
  static const int minPasswordLength = 8;

  static String? validateUsername(String? value) {
    // Make sure username is not empty
    if (value == null || value.isEmpty) {
      return 'Username is missing';
    }

    String usernameRegex = r'^[a-zA-Z][a-zA-Z0-9_-]{2,19}$';
    RegExp regex = RegExp(usernameRegex);

    if (!regex.hasMatch(value)) {
      return 'Username must be between $minUsernameLength to $maxUsernameLength characters long';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is missing';
    }
    // Simple email regex for validation
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null; // Returns null if validation passes
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is missing';
    }

    // At least minPasswordLength characters
    if (value.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters long';
    }

    // At least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must have at least one uppercase letter';
    }

    // At least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must have at least one lowercase letter';
    }

    // At least one digit
    if (!RegExp(r'\d').hasMatch(value)) {
      return 'Password must have at least one number';
    }

    // At least one special character
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must have at least one special character';
    }

    return null;
  }
}