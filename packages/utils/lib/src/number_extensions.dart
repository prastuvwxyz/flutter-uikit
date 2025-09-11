import 'dart:math';
import 'package:intl/intl.dart';

/// Extension methods for num class
extension NumberExtensions on num {
  /// Format number as currency
  String toCurrency({String symbol = '\$', int decimalDigits = 2}) {
    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(this);
  }

  /// Format number with thousands separator
  String toFormattedString({int decimalDigits = 0}) {
    final formatter = NumberFormat.decimalPattern();
    if (decimalDigits > 0) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }
    return formatter.format(this);
  }

  /// Convert to percentage string
  String toPercentage({int decimalDigits = 1}) {
    final formatter = NumberFormat.percentPattern();
    formatter.minimumFractionDigits = decimalDigits;
    formatter.maximumFractionDigits = decimalDigits;
    return formatter.format(this / 100);
  }

  /// Check if number is between two values (inclusive)
  bool isBetween(num min, num max) {
    return this >= min && this <= max;
  }

  /// Round to specific decimal places
  double roundToDecimals(int places) {
    final mod = pow(10.0, places).toDouble();
    return (this * mod).round().toDouble() / mod;
  }
}

/// Additional utility functions for numbers
class NumberUtils {
  /// Parse string to double with fallback
  static double parseDouble(String value, {double fallback = 0.0}) {
    return double.tryParse(value) ?? fallback;
  }

  /// Parse string to int with fallback
  static int parseInt(String value, {int fallback = 0}) {
    return int.tryParse(value) ?? fallback;
  }

  /// Generate a random number between min and max
  static double randomBetween(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
}
