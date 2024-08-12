import 'package:equatable/equatable.dart';

class News extends Equatable {
  final String title;
  final String source;

  const News({
   required this.source,
   required this.title
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
     source: json['author'],
     title: json['title']
    );
  }

  factory News.initial() => const News(
       source: '',
       title: '',
      );

  @override
  List<Object> get props {
    return [
     source,title
    ];
  }
}
