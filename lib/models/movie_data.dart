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

  factory MovieData.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String title = json['title'] as String;
    final int year = json['year'] as int;
    final String rating = json['rating'] as String;
    final String description = json['description'] as String;
    final String imagePath = json['imagePath'] as String;
    final String date = json['date'] as String;
    final double price = (json['price'] as num).toDouble();

    return MovieData(
      id: id,
      title: title,
      year: year,
      rating: rating,
      description: description,
      imagePath: imagePath,
      date: date,
      price: price,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'description': description,
      'imagePath': imagePath,
      'date': date,
      'price': price,
    };
    return data;
  }
}
