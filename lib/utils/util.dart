/// Util class for common function
class Util {
  /// Check if String is numeric
  /// [s]: Source in String
  /// return: true - is numeric
  /// return: false - is not numeric
  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /// Check if email format is correct
  /// [s]: Source in String
  /// return: true - valid email format
  /// return: false - invalid email format
  static bool validateEmail(String s) {
    if (s == null) {
      return false;
    }
    return RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(s);
  }

  /// Check if vehicle number format is correct
  /// [s]: Source in String
  /// return: true - valid vehicle number format
  /// return: false - invalid vehicle number format
  static bool validateVehicleNumber(String s) {
    if (s == null) {
      return false;
    }
    return RegExp(r'^[_A-z0-9]*((-|\s)*[_A-z0-9])*$').hasMatch(s);
  }
}
