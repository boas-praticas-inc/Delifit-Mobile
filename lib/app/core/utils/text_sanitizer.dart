class TextSanitizer {
  static String apenasDigitos(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  static String apenasLetras(String value) {
    return value.replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }
}
