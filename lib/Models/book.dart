class Book {
  final String id;
  final String title;
  final String author;
  final double replacementPrice;
  bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.replacementPrice,
    this.isAvailable = true,
  });
}