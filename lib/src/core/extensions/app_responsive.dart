class AppResponsive {
  static final AppResponsive _instance = AppResponsive._internal();
  factory AppResponsive() => _instance;
  AppResponsive._internal();

  late String apiUrl;
  late bool isDarkMode;

  void init({required String apiUrl, required bool isDarkMode}) {
    this.apiUrl = apiUrl;
    this.isDarkMode = isDarkMode;
  }
}
