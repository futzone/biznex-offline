class ApiEndpoints {
  static const String baseUrl = "http://localhost:8000";
  static const String client = "/clients/client";
  static String clientOne (id)=> "/clients/$id";
  static String clientsAll (page, pageSize)=> "/clients/list/$page/$pageSize";
}
