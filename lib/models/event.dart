class Event {
  final String title;
  final String date;
  final String month;
  final double price;
  final String imageUrl;
  final String distance;
  
  const Event({
    required this.title,
    required this.date,
    required this.month,
    required this.price,
    required this.imageUrl,
    this.distance = '1.2 km',
  });

  // Factory constructor to create Event from JSON
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['title'] as String,
      date: json['date'] as String,
      month: json['month'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      distance: json['distance'] as String? ?? '1.2 km',
    );
  }

  // Convert Event to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date,
      'month': month,
      'price': price,
      'imageUrl': imageUrl,
      'distance': distance,
    };
  }

  // Copy with method for immutability
  Event copyWith({
    String? title,
    String? date,
    String? month,
    double? price,
    String? imageUrl,
    String? distance,
  }) {
    return Event(
      title: title ?? this.title,
      date: date ?? this.date,
      month: month ?? this.month,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      distance: distance ?? this.distance,
    );
  }
}