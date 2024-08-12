part of 'news_cubit.dart';

enum NewsStatus {
  initial,
  loading,
  loaded,
  error,
}

class NewsState extends Equatable {
  final List<News>news;
  final NewsStatus status;
  final CustomError error;
  NewsState({
    required this.status,
    required this.news,
    required this.error,
  });

  factory NewsState.initial() {
    return NewsState(
      status: NewsStatus.initial,
     news: [],
      error: const CustomError(),
    );
  }

  @override
  List<Object> get props => [status, news, error];


  NewsState copyWith({
    NewsStatus? status,
    List<News>? news,
    CustomError? error,
  }) {
    return NewsState(
      status: status ?? this.status,
      news: news ?? this.news,
      error: error ?? this.error,
    );
  }
}
