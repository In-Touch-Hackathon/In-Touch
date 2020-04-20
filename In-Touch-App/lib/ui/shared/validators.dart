String emailValidator (String value) {
  RegExp regex = new RegExp(r"^.+@.+\..+$");
  if (!regex.hasMatch(value)) {
    return 'Invalid email address';
  }
  return null;
}

String displayNameValidator (String value) {
  if (value.trim().length < 1) {
    return 'Invalid display name';
  }
  return null;
}

