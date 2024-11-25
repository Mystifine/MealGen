class APIConstants {
  //**
  // Store API Constants for API requests.
  // */

  // When pushing to live would change baseURL.
  static const String baseUrl = "http://127.0.0.1:5000";

  static const String loginEndpoint = "$baseUrl/auth/login";
  static const String signupEndpoint = "$baseUrl/auth/signup";
}