import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

/// Guarda a lista de livros localmente (lista de JSONs no shared_preferences).
class BookStorage {
  static const _key = 'books';

  Future<List<Book>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];
    return raw.map(Book.fromJson).toList();
  }

  Future<void> save(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, books.map((b) => b.toJson()).toList());
  }
}
