class StringUtils{
  static const EMPTY_STRING = '';

  static bool isEmpty(String string) =>  string == null || string.isEmpty;
  static bool isNotEmpty(String string) => string != null && string.isNotEmpty;
}