String? emailValidator(String? value) {
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value!)) {
    return 'Enter a valid email!';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please enter password';
  } else if (value.length < 6) {
    return "Password must be 6 character";
  } else {
    return null;
  }
}

String? textFieldValidator(String? value) {
  if (value!.isEmpty) {
    return 'Please fill the field';
  } else {
    return null;
  }
}
