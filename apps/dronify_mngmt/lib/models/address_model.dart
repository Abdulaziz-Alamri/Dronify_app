class AddressModel {
  final int addressId;
  final int orderId;
  final String latitude;
  final String longitude;

  AddressModel({
    required this.addressId,
    required this.orderId,
    required this.latitude,
    required this.longitude,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json['address_id'],
      orderId: json['order_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': addressId,
      'order_id': orderId,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
