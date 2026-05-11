import 'package:equatable/equatable.dart';

class QuoteModel extends Equatable {
  final String content;
  final String author;

  const QuoteModel({
    required this.content,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      content: json['content'] ?? '',
      author: json['author'] ?? 'Unknown',
    );
  }

  @override
  List<Object?> get props => [content, author];
}
