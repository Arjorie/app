// Account Model
class AccountModel {
  String username;
  String firstName;
  String lastName;
  String gender;
  String birthDate;
  String profilePicture;
  int status;
  String role;
  var roles = ['Waiter', 'Cashier'];

  AccountModel(
      {this.username,
      this.firstName,
      this.lastName,
      this.gender,
      this.birthDate,
      this.profilePicture,
      this.status,
      this.role});

  factory AccountModel.fromJson(Map<String, dynamic> account) {
    final roles = ['Waiter', 'Cashier'];
    final accountRole = roles[account['role']];
    final accountProfile = account['employee_profile'];
    return AccountModel(
      username: account['username'],
      firstName: accountProfile['first_name'],
      lastName: accountProfile['last_name'],
      gender: accountProfile['gender'],
      birthDate: accountProfile['birth_date'],
      profilePicture: accountProfile['profile_picture'],
      status: account['status'],
      role: accountRole,
    );
  }
}
