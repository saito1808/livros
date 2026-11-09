import 'dart:convert';

class Book {
  final String id;
  final String title;
  final String author;
  final int rating; // 0 a 5 (só vale para livros lidos)
  final bool isRead;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.rating = 0,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'author': author,
        'rating': rating,
        'isRead': isRead,
      };

  factory Book.fromMap(Map<String, dynamic> map) => Book(
        id: map['id'] as String,
        title: map['title'] as String,
        author: map['author'] as String,
        rating: (map['rating'] ?? 0) as int,
        isRead: (map['isRead'] ?? false) as bool,
      );

  String toJson() => jsonEncode(toMap());
  factory Book.fromJson(String source) =>
      Book.fromMap(jsonDecode(source) as Map<String, dynamic>);
}
