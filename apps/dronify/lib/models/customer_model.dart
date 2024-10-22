class CustomerModel {
  final String customerId;
  final String name;
  final String email;
  final String phone;
  final String role;

  CustomerModel({
    required this.customerId,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'customer',
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      customerId: json['customer_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }
}