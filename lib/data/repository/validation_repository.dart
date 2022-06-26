class ValidationRepository {
  bool isValidFirstName(String firstName) => firstName.trim().isNotEmpty;
  bool isValidLastName(String lastName) => lastName.trim().isNotEmpty;
  bool isValidUsername(String username) => username.trim().length >= 3;
  bool isValidPhone(String phone) => validatePhone(phone.trim());
  bool isValidEmail(String email) => validateEmail(email.trim());
  bool isValidPassword(String password) => password.length >= 8;
  bool isValidBirthdate(String date) => _isAdult(date);
  bool validatePhone(String s) {
    return RegExp(r'^(?:[+][0-9])?[0-9]{10,30}$').hasMatch(s);
  }

  bool validateEmail(String s) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(s);
  }

  bool _isAdult(String s) {
    final DateTime myDatetime = DateTime.parse(s);
    final DateTime _currentDate = DateTime.now();
    final _comparable =
        DateTime(_currentDate.year - 16, _currentDate.month, _currentDate.day);

    final Duration _diff1 = _currentDate.difference(myDatetime);
    final Duration _diff2 = _currentDate.difference(_comparable);

    return _diff1.inDays >= _diff2.inDays;
  }
}

enum Fields {
  firstname,
  lastname,
  birthdate,
  username,
  password,
  email,
  mobile
}
