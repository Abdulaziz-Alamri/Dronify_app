class ServiceModel {
  final int serviceId;
  final String name;
  final String description;
  final String mainImage;
  final double pricePerSqm;
  final String iconPath;

  ServiceModel({
    required this.serviceId,
    required this.name,
    required this.description,
    required this.mainImage,
    required this.pricePerSqm,
    required this.iconPath
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json['service_id'],
      name: json['name'],
      description: json['description'],
      mainImage: json['main_image'],
      pricePerSqm: json['price_per_sqm'].toDouble(),
      iconPath: json['icon_path']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'name': name,
      'description': description,
      'main_image': mainImage,
      'price_per_sqm': pricePerSqm,
      'icon_path': iconPath,
    };
  }
}
