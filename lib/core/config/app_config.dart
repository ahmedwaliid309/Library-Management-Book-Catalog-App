class AppConfig {
  AppConfig._();

  static const String booksApiKey = String.fromEnvironment('BOOKS_API_KEY');

  // لو المفتاح مش موجود، التطبيق يشتغل على الداتا التجريبية بدل ما يقع
  static bool get hasApiKey => booksApiKey.isNotEmpty;
}