import 'package:biznex/src/server/requests.dart';

class ApiRequest {
  String name;
  String path;
  Map<String, dynamic> params;
  Map<String, String> headers;
  Map<String, String> errorResponse;
  String method;
  String body;
  String contentType;
  dynamic response;

  ApiRequest({
    required this.name,
    required this.path,
    this.params = const {},
    this.headers = const {},
    required this.method,
    this.body = '',
    this.contentType = 'application/json',
    this.response,
    required this.errorResponse,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'path': path,
        'params': params,
        'headers': headers,
        'method': method,
        'body': body,
        'contentType': contentType,
        'response': response,
        'errorResponse': errorResponse,
      };

  factory ApiRequest.fromJson(Map<String, dynamic> json) {
    return ApiRequest(
      name: json['name'],
      path: json['path'],
      params: Map<String, dynamic>.from(json['params'] ?? {}),
      headers: Map<String, String>.from(json['headers'] ?? {}),
      method: json['method'],
      body: json['body'] ?? '',
      contentType: json['contentType'] ?? 'application/json',
      response: json['response'],
      errorResponse: json['errorResponse'],
    );
  }
}

String renderApiRequests() {
  final requests = serverRequestsList();
  String htmlContent = '''
  <!DOCTYPE html>
  <html lang="en">
  <head>
    <meta charset="UTF-8">
    <title>Biznex Swagger UI</title>
    <style>
      body { font-family: sans-serif; padding: 20px; }
      .request-box { border: 1px solid #ccc; padding: 16px; margin-bottom: 20px; border-radius: 8px; }
      .request-box h2 { margin: 0 0 10px 0; }
      .method { font-weight: bold; color: white; padding: 4px 8px; border-radius: 4px; }
      .GET { background: green; }
      .POST { background: blue; }
      .PUT { background: orange; }
      .DELETE { background: red; }
      textarea { width: 100%; height: 100px; }
      pre { background: #eee; padding: 10px; border-radius: 4px; }
    </style>
  </head>
  <body>
    <h1>🧩 Biznex Swagger UI</h1>
  ''';

  for (var request in requests) {
    htmlContent += '''
    <div class="request-box">
      <h2>${request.name}</h2>
      <div><span class="method ${request.method}">${request.method}</span> <code> ${request.path}</code></div>
      <pre id="response-${request.headers.hashCode}">Request headers: ${request.headers}</pre>
      <pre id="response-${request.params.hashCode}">Request params: ${request.params}</pre>
      <pre id="response-${request.path}">Request body: ${request.body}</pre>
      <pre id="response-${request.response.hashCode}">Response example: ${request.response ?? '{}'}</pre>
      <pre id="response-${request.errorResponse.hashCode}">Error Response Example: ${request.errorResponse ?? '{}'}</pre>
    </div>
    ''';
  }

  htmlContent += '''
  <script>
    function sendRequest(method, path, body) {
      fetch(path, {
        method: method,
        headers: { 'Content-Type': 'application/json' },
        body: body ? JSON.stringify(body) : undefined
      })
      .then(response => response.text())
      .then(data => document.getElementById('response-' + path).textContent = data)
      .catch(error => document.getElementById('response-' + path).textContent = 'Error: ' + error);
    }
  </script>
  </body>
  </html>
  ''';

  return htmlContent;
}
