import 'package:flutter/foundation.dart';
import 'package:wealthwise/models/news_model.dart';
import 'package:wealthwise/repositories/news_repository.dart';

class NewsProvider extends ChangeNotifier{
  final NewsRepository _newsRepository = NewsRepository();
  List<NewsModel> _news =[];
  bool _isLoading = false;
  String? _error;
  List<NewsModel> get news => _news;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Future<void> fetchNews() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _news = await _newsRepository.fetchnews();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}