import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class HttpService {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3000', // Remplace par ton URL de backend
      validateStatus: (_) => true, // Pour gérer les codes manuellement
      followRedirects: false,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static final CookieJar cookieJar = CookieJar();

  static void init() {
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        requestHeader: true,
        error: true,
        logPrint: (obj) => print("[DIO] $obj"),
      ),
    );
    dio.interceptors.add(CookieManager(cookieJar));
  }
}
