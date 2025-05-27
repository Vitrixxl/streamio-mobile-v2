import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

final dio = Dio();
final cookieJar = CookieJar();

void setupDio() {
  dio.interceptors.add(CookieManager(cookieJar));
}
