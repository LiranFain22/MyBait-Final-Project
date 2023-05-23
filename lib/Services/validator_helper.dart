class ValidatorHelper {
  static bool containsOnlyCharacters(String text) {
    final RegExp regex = RegExp(r'^[a-zA-Z]+$');
    return regex.hasMatch(text);
  }

  static bool containsOnlyNumbers(String text) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(text);
  }
}
