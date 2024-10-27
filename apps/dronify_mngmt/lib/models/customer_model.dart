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
      customerId:
          json['customer_id'] ?? '', // إذا كانت `customer_id` غير موجودة
      name: json['name'] ?? 'Unknown', // إذا كانت `name` غير موجودة
      email: json['email'] ??
          'no-email@unknown.com', // إذا كانت `email` غير موجودة
      phone: json['phone'] ?? 'No Phone', // إذا كانت `phone` غير موجودة
      role: json['role'] ?? 'customer', // إذا كانت `role` غير موجودة
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
