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
    print(account);
    final roles = ['Waiter', 'Cashier'];
    final accountRole = roles[account['role']];
    return AccountModel(
      username: account['username'],
      firstName: account['first_name'],
      lastName: account['last_name'],
      gender: account['gender'],
      birthDate: account['birth_date'],
      profilePicture: account['profile_picture'],
      status: account['status'],
      role: accountRole,
    );
  }
}
