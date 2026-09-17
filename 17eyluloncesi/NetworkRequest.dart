class NetworkRequest {
  final String url;
  final String method;
  final Map<String, String>? headers;
  final Map<String, dynamic>? body;
  final int timeoutSeconds;
  final bool requiresAuth;

  // Kurucu private: Dışarıdan doğrudan new NetworkRequest(...) yapılamaz!
  NetworkRequest._(NetworkRequestBuilder builder)
      : url = builder.url,
        method = builder.method,
        headers = builder.headers,
        body = builder.body,
        timeoutSeconds = builder.timeoutSeconds,
        requiresAuth = builder.requiresAuth;

  @override
  String toString() => "[$method] $url (Auth: $requiresAuth, Timeout: ${timeoutSeconds}s)";
}

// İnşaatçı Sınıf (Builder)
class NetworkRequestBuilder {
  final String url; // Zorunlu parametre
  String method = "GET"; // Varsayılanlar
  Map<String, String>? headers;
  Map<String, dynamic>? body;
  int timeoutSeconds = 30;
  bool requiresAuth = true;

  NetworkRequestBuilder(this.url);

  // Her metot 'this' döndürerek zincirleme (chaining) çağrı sağlar:
  NetworkRequestBuilder setMethod(String method) {
    this.method = method;
    return this;
  }

  NetworkRequestBuilder setHeaders(Map<String, String> headers) {
    this.headers = headers;
    return this;
  }

  NetworkRequestBuilder setBody(Map<String, dynamic> body) {
    this.body = body;
    return this;
  }

  NetworkRequestBuilder setTimeout(int seconds) {
    this.timeoutSeconds = seconds;
    return this;
  }

  NetworkRequestBuilder setRequiresAuth(bool auth) {
    this.requiresAuth = auth;
    return this;
  }

  // Son vuruş: Gerçek nesneyi doğrulayarak inşa et!
  NetworkRequest build() {
    if (!url.startsWith("https://")) {
      throw ArgumentError("Güvenlik hatası: URL kesinlikle HTTPS olmalıdır!");
    }
    return NetworkRequest._(this);
  }
}

void main() {
  // Akıcı, okunabilir ve güvenli kullanım:
  final request = NetworkRequestBuilder("https://api.kodvance.com/v1/orders")
      .setMethod("POST")
      .setTimeout(10)
      .setBody({"productId": 42, "quantity": 1})
      .build();

  print(request);
}