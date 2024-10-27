class ImageModel {
  final int imageId;
  final int orderId;
  final String? type;
  final String imageUrl;
  final DateTime createdAt;

  ImageModel({
    required this.imageId,
    required this.orderId,
    this.type,
    required this.imageUrl,
    required this.createdAt,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      imageId: json['image_id'],
      orderId: json['order_id'],
      type: json['type'],
      imageUrl: json['image_url'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_id': imageId,
      'order_id': orderId,
      'type': type,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
