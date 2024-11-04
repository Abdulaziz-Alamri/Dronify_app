class EmployeeModel {
  final String employeeId;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? position;
  final double? rating;
  final String? imageUrl;

  EmployeeModel({
    required this.employeeId,
    required this.name,
    required this.email,
    required this.phone,
    this.role = 'employee',
    required this.position,
    required this.rating,
    required this.imageUrl,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      employeeId: json['employee_id'],
      name: json['app_user']['name'],
      email: json['app_user']['email'],
      phone: json['app_user']['phone'],
      position: json['position'],
      rating: json['rating'] ?? 0,
      imageUrl: json['image_url'] ?? 'assets/pfp_emp.png');
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': employeeId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'position': position,
      'rating': rating,
      'image_url': imageUrl,
    };
  }
}
