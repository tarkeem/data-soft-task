import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/models/custom_error.dart';
import '../../model/models/news.dart';
import '../../model/repositories/news_repository.dart';

part 'news_state.dart';

class NewsCubit extends Cubit<NewsState> {
  final NewsRepository newsRepository;
  NewsCubit({required this.newsRepository})
      : super(NewsState.initial());

  Future<void> fetchNews(String category) async {
    emit(state.copyWith(status: NewsStatus.loading));

    try {
      final List<News>  news = await newsRepository.fetchNews(category);

      

      emit(state.copyWith(
        status: NewsStatus.loaded,
      news: news
      ));
      print('state: $state');
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: NewsStatus.error,
        error: e,
      ));
      print('state: $state');
    }
  }
}
