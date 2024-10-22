class RatingModel {
  final int ratingId;
  final String customerId;
  final int orderId;
  final double rating;
  final String review;
  final DateTime ratingDate;

  RatingModel({
    required this.ratingId,
    required this.customerId,
    required this.orderId,
    required this.rating,
    required this.review,
    required this.ratingDate,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      ratingId: json['rating_id'],
      customerId: json['customer_id'],
      orderId: json['order_id'],
      rating: json['rating'].toDouble(),
      review: json['review'],
      ratingDate: DateTime.parse(json['rating_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rating_id': ratingId,
      'customer_id': customerId,
      'order_id': orderId,
      'rating': rating,
      'review': review,
      'rating_date': ratingDate.toIso8601String(),
    };
  }
}
