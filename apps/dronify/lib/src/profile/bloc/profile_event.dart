abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class LogoutEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  final String name;
  final String phone;

  UpdateProfileEvent({
    required this.name,
    required this.phone,
  });

  List<Object> get props => [name, phone];
}
