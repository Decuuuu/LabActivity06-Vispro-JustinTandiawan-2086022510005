import 'package:flutter/foundation.dart';
import '../Models/book.dart';
import '../Models/loan.dart';

class LibraryViewModel extends ChangeNotifier {
  static const double weeklyFineRate = 5000.0;

  final List<Book> _books = [
    Book(id: 'B1', title: 'Pertempuran Sengit Ngawi', author: 'Amba', replacementPrice: 150000),
    Book(id: 'B2', title: 'Hutan Angker Ngawi', author: 'Imout Anwar', replacementPrice: 120000),
    Book(id: 'B3', title: 'Tutorial Unjuk Bakat Ala Mas Rian', author: 'Mas Rian', replacementPrice: 200000),
    Book(id: 'B4', title: 'Mitos Roh Ngawi Dan Pemanpakan Sosok Hytam Asli Ngawi', author: 'Ambajrun & Steven Suki', replacementPrice: 175000),
  ];

  final List<Loan> _loans = [];

  List<Book> get books => List.unmodifiable(_books);
  List<Loan> get loans => List.unmodifiable(_loans);


  String _searchQuery = '';
  String _filterStatus = 'Semua';

  String get searchQuery => _searchQuery;
  String get filterStatus => _filterStatus;

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    notifyListeners();
  }


  bool borrowBook(String bookId, String studentId) {
    final bookIndex = _books.indexWhere((b) => b.id == bookId);
    if (bookIndex == -1 || !_books[bookIndex].isAvailable) {
      return false;
    }


    final hasActiveLoan = _loans.any((l) => l.bookId == bookId && !l.isReturned);
    if (hasActiveLoan) return false;

    _books[bookIndex].isAvailable = false;

    final now = DateTime.now();
    final dueDate = now.add(const Duration(days: 14));

    _loans.add(
      Loan(
        id: 'L${_loans.length + 1}',
        bookId: bookId,
        studentId: studentId,
        borrowDate: now,
        dueDate: dueDate,
      ),
    );

    notifyListeners();
    return true;
  }


  void returnBook(String loanId) {
    final loanIndex = _loans.indexWhere((l) => l.id == loanId);
    if (loanIndex == -1 || _loans[loanIndex].isReturned) return;

    final loan = _loans[loanIndex];
    loan.returnDate = DateTime.now();


    final bookIndex = _books.indexWhere((b) => b.id == loan.bookId);
    if (bookIndex != -1) {
      _books[bookIndex].isAvailable = true;
    }

    if (loan.status != LoanStatus.missing) {
      loan.status = LoanStatus.returned;
    }

    notifyListeners();
  }


  double calculateFine(Loan loan) {
    final checkDate = loan.returnDate ?? DateTime.now();


    if (!checkDate.isAfter(loan.dueDate)) {
      return 0.0;
    }


    final sixMonthsAfterDue = DateTime(
      loan.dueDate.year,
      loan.dueDate.month + 6,
      loan.dueDate.day,
    );

    if (checkDate.isAfter(sixMonthsAfterDue) || checkDate.isAtSameMomentAs(sixMonthsAfterDue)) {
      loan.status = LoanStatus.missing;
      final book = _books.firstWhere((b) => b.id == loan.bookId, orElse: () => Book(id: '', title: '', author: '', replacementPrice: 0));
      return book.replacementPrice;
    }


    final differenceInDays = checkDate.difference(loan.dueDate).inDays;
    final completedWeeks = differenceInDays ~/ 7;

    return completedWeeks * weeklyFineRate;
  }


  Book? getBookById(String bookId) {
    try {
      return _books.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }


  double get totalOutstandingFines {
    return _loans
        .where((l) => !l.isReturned)
        .fold(0.0, (sum, loan) => sum + calculateFine(loan));
  }
}