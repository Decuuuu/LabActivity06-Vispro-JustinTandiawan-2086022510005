import 'package:flutter/material.dart';
import '../viewmodels/library_view_model.dart';
import 'book_card.dart';
import 'loan_card.dart';

class LibraryScreen extends StatelessWidget {
  final LibraryViewModel viewModel;

  const LibraryScreen({super.key, required this.viewModel});

  void _showBorrowDialog(BuildContext context, String bookId) {
    final studentIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pinjam Buku'),
        content: TextField(
          controller: studentIdController,
          decoration: const InputDecoration(labelText: 'Masukkan NIM Mahasiswa'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              if (studentIdController.text.isNotEmpty) {
                final success = viewModel.borrowBook(bookId, studentIdController.text);
                Navigator.pop(ctx);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Buku gagal dipinjam!')),
                  );
                }
              }
            },
            child: const Text('Pinjam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Perpustakaan Ngawi'),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.menu_book), text: 'Katalog Buku'),
                  Tab(icon: Icon(Icons.history), text: 'Peminjaman & Denda'),
                ],
              ),
            ),
            body: TabBarView(
              children: [

                ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: viewModel.books.length,
                  itemBuilder: (context, index) {
                    final book = viewModel.books[index];
                    return BookCard(
                      book: book,
                      onBorrow: () => _showBorrowDialog(context, book.id),
                    );
                  },
                ),


                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Denda Belum Terbayar:', style: TextStyle(fontSize: 16)),
                          Text(
                            'Rp ${viewModel.totalOutstandingFines.toInt()}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: viewModel.loans.isEmpty
                          ? const Center(child: Text('Belum ada transaksi peminjaman.'))
                          : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: viewModel.loans.length,
                        itemBuilder: (context, index) {
                          final loan = viewModel.loans[index];
                          final book = viewModel.getBookById(loan.bookId);
                          final fine = viewModel.calculateFine(loan);

                          return LoanCard(
                            loan: loan,
                            book: book,
                            fineAmount: fine,
                            onReturn: () => viewModel.returnBook(loan.id),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}