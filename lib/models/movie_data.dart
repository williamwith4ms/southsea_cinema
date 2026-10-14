class MovieData {
  final String id;
  final String title;
  final int year;
  final String rating;
  final String description;
  final String imagePath;
  final String date;
  final double price;

  const MovieData({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.description,
    required this.imagePath,
    required this.date,
    required this.price,
  });

  String get formattedPrice => '£${price.toStringAsFixed(2)}';
}
