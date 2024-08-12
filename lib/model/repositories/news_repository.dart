import 'dart:developer';

import '../../utils/weather_exception.dart';
import '../models/custom_error.dart';
import '../models/news.dart';
import '../../services/api_services.dart';

class NewsRepository {
  final NewsApiServices newsApiServices;
  NewsRepository({
    required this.newsApiServices,
  });

  Future<List< News>> fetchNews(String category) async {
   
    try {
      final Map<String,dynamic> res  =await newsApiServices.getNews(category);
       
      
       log('in repo............................');
       log(res.length.toString());
       final List articles=res['articles'];
      log(articles.toString());
      List<News>newsArticle=[];
      
      for (var element in articles) {
        newsArticle.add(News.fromJson(element));
      }
      return newsArticle;
    } on NewsException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}