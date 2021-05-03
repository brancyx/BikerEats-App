/// Handles the logic concerning passwords
class PasswordManager {
  int minLength = 8; // minimum length of valid password

  /// Checks if password fulfils the requirement of having at least 8 characters,
  /// has special character, has number,  has uppercase and has lowercase.
  int isValidPassword(String password) {
    if (password.length < minLength) {
      return -1;
    }
    if (!password.contains(new RegExp(r'[A-Z]'))) {
      return -2;
    }
    if (!password.contains(new RegExp(r'[a-z]'))) {
      return -3;
    }
    if (!password.contains(new RegExp(r'[0-9]'))) {
      return -4;
    }
    if (!password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return -5;
    }
    return 1;
  }
}