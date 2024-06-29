import 'dart:io';

class ProxyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..findProxy = (uri) {
        return 'PROXY 127.0.0.1:9090;';
      }
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}