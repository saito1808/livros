import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_storage.dart';
import 'book_form_screen.dart';
import 'top5_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = BookStorage();
  List<Book> _books = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final books = await _storage.load();
    setState(() {
      _books = books;
      _loading = false;
    });
  }

  Future<void> _openForm({Book? book}) async {
    final result = await Navigator.push<Book>(
      context,
      MaterialPageRoute(builder: (_) => BookFormScreen(book: book)),
    );
    if (result == null) return;
    setState(() {
      final index = _books.indexWhere((b) => b.id == result.id);
      if (index >= 0) {
        _books[index] = result;
      } else {
        _books.add(result);
      }
    });
    await _storage.save(_books);
  }

  Future<void> _delete(Book book) async {
    setState(() => _books.removeWhere((b) => b.id == book.id));
    await _storage.save(_books);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('"${book.title}" removido')),
    );
  }

  Widget _buildList(List<Book> books, String emptyText) {
    if (books.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (_, i) {
        final book = books[i];
        return Dismissible(
          key: ValueKey(book.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (_) => _delete(book),
          child: ListTile(
            title: Text(book.title),
            subtitle: Text(book.author),
            trailing: book.isRead
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                      Text(' ${book.rating}'),
                    ],
                  )
                : null,
            onTap: () => _openForm(book: book),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final read = _books.where((b) => b.isRead).toList();
    final wishlist = _books.where((b) => !b.isRead).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meus Livros'),
          actions: [
            IconButton(
              tooltip: 'Top 5',
              icon: const Icon(Icons.emoji_events),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Top5Screen(books: _books)),
              ),
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'Lidos'), Tab(text: 'Desejados')],
          ),
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildList(read, 'Nenhum livro lido ainda.'),
                  _buildList(wishlist, 'Nenhum livro desejado ainda.'),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openForm(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
