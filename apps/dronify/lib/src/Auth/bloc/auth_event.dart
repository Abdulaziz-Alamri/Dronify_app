abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;
  final String username;
  final String phone;

  SignUpEvent({required this.email, required this.password ,required this.username, required this.phone});
}
