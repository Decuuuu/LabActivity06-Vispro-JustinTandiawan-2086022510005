import 'package:flutter/material.dart';
import '../Models/book.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onBorrow;

  const BookCard({super.key, required this.book, this.onBorrow});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Penulis: ${book.author}\nHarga Ganti: Rp ${book.replacementPrice.toInt()}'),
        isThreeLine: true,
        trailing: ElevatedButton(
          onPressed: book.isAvailable ? onBorrow : null,
          child: Text(book.isAvailable ? 'Pinjam' : 'Dipinjam'),
        ),
      ),
    );
  }
}