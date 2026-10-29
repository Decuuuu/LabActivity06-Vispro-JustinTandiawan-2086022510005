enum LoanStatus { active, returned, missing }

class Loan {
  final String id;
  final String bookId;
  final String studentId;
  final DateTime borrowDate;
  final DateTime dueDate;
  DateTime? returnDate;
  LoanStatus status;

  Loan({
    required this.id,
    required this.bookId,
    required this.studentId,
    required this.borrowDate,
    required this.dueDate,
    this.returnDate,
    this.status = LoanStatus.active,
  });

  bool get isReturned => returnDate != null;
}