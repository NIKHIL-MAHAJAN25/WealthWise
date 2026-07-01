import 'package:dio/dio.dart';
class DioClient{
  static final Dio dioo = Dio(
    BaseOptions(baseUrl: 'https://api.marketaux.com/v1' ,
    connectTimeout: const Duration(seconds:10),
    receiveTimeout: const Duration(seconds: 10)
  ),);
}