/// Validation utilities for common use cases
class ValidationUtils {
  /// Email validation regex
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  /// Phone validation regex (basic)
  static final RegExp _phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');

  /// Validate email address
  static bool isValidEmail(String email) {
    return _emailRegex.hasMatch(email);
  }

  /// Validate phone number
  static bool isValidPhone(String phone) {
    return _phoneRegex.hasMatch(phone);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, digit, and special char
    return password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  /// Validate URL
  static bool isValidUrl(String url) {
    try {
      Uri.parse(url);
      return url.startsWith('http://') || url.startsWith('https://');
    } catch (e) {
      return false;
    }
  }

  /// Validate credit card number (Luhn algorithm)
  static bool isValidCreditCard(String cardNumber) {
    if (cardNumber.isEmpty) return false;

    final sanitized = cardNumber.replaceAll(RegExp(r'\D'), '');
    if (sanitized.length < 13 || sanitized.length > 19) return false;

    var sum = 0;
    var alternate = false;

    for (var i = sanitized.length - 1; i >= 0; i--) {
      var digit = int.parse(sanitized[i]);

      if (alternate) {
        digit *= 2;
        if (digit > 9) {
          digit = (digit % 10) + 1;
        }
      }

      sum += digit;
      alternate = !alternate;
    }

    return sum % 10 == 0;
  }

  /// Validate required field
  static bool isRequired(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  /// Validate minimum length
  static bool hasMinLength(String value, int minLength) {
    return value.length >= minLength;
  }

  /// Validate maximum length
  static bool hasMaxLength(String value, int maxLength) {
    return value.length <= maxLength;
  }

  /// Validate numeric value
  static bool isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  /// Validate integer value
  static bool isInteger(String value) {
    return int.tryParse(value) != null;
  }
}
