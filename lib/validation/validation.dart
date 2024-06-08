class Validation{

  emailValidation(email){
    if (email!.isEmpty ||
        email.trim().isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@"
        r"[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }
}