import 'package:dio/dio.dart';
import 'package:wealthwise/models/news_model.dart';
import 'package:wealthwise/services/dio_news.dart';

class NewsRepository {
  Future<List<NewsModel>> fetchnews() async {
    final Response response = await DioClient.dioo.get(
      '/news/all',
      queryParameters: {
        'api_token': 'QRZoaT0L7HRbn0VCDrm5SeHOpwVdeeaPXXWOGF9K',
        'countries': 'in',
        'language': 'en',
        'limit': 20,
      },
    );
    final List<dynamic> newsList = response.data['data'];

    return newsList.map((news) => NewsModel.fromJson(news)).toList();
  }
}
