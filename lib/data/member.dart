class Member{
  final String name;
  final String email;
  final String role;

  Member({this.name, this.email, this.role});

  @override
  String toString() {
    return 'Member{name: $name, email: $email, role: $role}';
  }


}