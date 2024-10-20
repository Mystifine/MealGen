class Validators {
  static const int minUsernameLength = 3;
  static const int minPasswordLength = 6;

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }

    if (value.length < minUsernameLength) {
      return 'Username must be at least $minUsernameLength characters long';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
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
      return 'Password is required';
    }

    if (value.length < minPasswordLength) {
      return 'Password must be at least $minPasswordLength characters long';
    }
    return null;
  }
}