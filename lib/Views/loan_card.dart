import 'package:flutter/material.dart';
import '../Models/book.dart';
import '../Models/loan.dart';

class LoanCard extends StatelessWidget {
  final Loan loan;
  final Book? book;
  final double fineAmount;
  final VoidCallback? onReturn;

  const LoanCard({
    super.key,
    required this.loan,
    required this.book,
    required this.fineAmount,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    final isMissing = loan.status == LoanStatus.missing;
    final isOverdue = fineAmount > 0 && !isMissing;

    Color statusColor = Colors.green;
    String statusText = 'Aktif';

    if (loan.isReturned) {
      statusColor = Colors.grey;
      statusText = 'Dikembalikan';
    } else if (isMissing) {
      statusColor = Colors.purple;
      statusText = 'MISSING (Hilang)';
    } else if (isOverdue) {
      statusColor = Colors.red;
      statusText = 'Overdue';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    book?.title ?? 'Buku #${loan.bookId}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Chip(
                  label: Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('NIM Peminjam: ${loan.studentId}'),
            Text('Jatuh Tempo: ${loan.dueDate.day}/${loan.dueDate.month}/${loan.dueDate.year}'),
            if (fineAmount > 0)
              Text(
                'Denda: Rp ${fineAmount.toInt()}',
                style: TextStyle(color: isMissing ? Colors.purple : Colors.red, fontWeight: FontWeight.bold),
              ),
            if (!loan.isReturned)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: onReturn,
                  icon: const Icon(Icons.assignment_return),
                  label: const Text('Kembalikan'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}