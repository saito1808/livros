import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../models/book.dart';
import '../widgets/ranking_card.dart';

class Top5Screen extends StatelessWidget {
  final List<Book> books;
  Top5Screen({super.key, required List<Book> books})
      : books = (books.where((b) => b.isRead && b.rating > 0).toList()
              ..sort((a, b) => b.rating.compareTo(a.rating)))
            .take(5)
            .toList();

  final _controller = ScreenshotController();

  Future<void> _share(BuildContext context) async {
    try {
      final bytes = await _controller.captureFromWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MediaQuery(
            data: const MediaQueryData(),
            child: Material(child: RankingCard(books: books)),
          ),
        ),
        pixelRatio: 3,
        delay: const Duration(milliseconds: 100),
      );
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/top5_livros.png');
      await file.writeAsBytes(bytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Meu Top 5 de livros 📚',
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao compartilhar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top 5')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: RankingCard(books: books),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: books.isEmpty ? null : () => _share(context),
        icon: const Icon(Icons.share),
        label: const Text('Compartilhar'),
      ),
    );
  }
}
