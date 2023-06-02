class ValidatorHelper {
  static bool isEmail(String text) {
    final RegExp regex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,}$');
    return regex.hasMatch(text);
  }

  static bool containsOnlyCharacters(String text) {
    final RegExp regex = RegExp(r'^[a-zA-Z][a-zA-Z\s]*$');
    return regex.hasMatch(text);
  }

  static bool containsOnlyNumbers(String text) {
    final RegExp regex = RegExp(r'^[0-9]+$');
    return regex.hasMatch(text);
  }
}
