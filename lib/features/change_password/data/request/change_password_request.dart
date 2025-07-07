class ChangePasswordRequest {
  String oldPassword;
  String password;
  String passwordConfirmation;

  ChangePasswordRequest({
    required this.oldPassword,
    required this.password,
    required this.passwordConfirmation,
  });
}
