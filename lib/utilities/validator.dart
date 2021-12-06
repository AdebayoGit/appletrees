class Validator {
  static String? nameValidator(String? name) {
    if (name!.isEmpty) {
      return 'Full Name is required';
    } else if (name.length < 8) {
      return 'Full name should be eight characters or more';
    }
    if (name.split(' ').length < 2){
      return 'At least two names required';
    }
    return null;
  }

  static String? emailValidator(String? email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email!);
    if (email.isEmpty) {
      return 'Email is required';
    } else if (!emailValid){
      return 'Please provide a valid email address';
    }
    return null;
  }

  static String? phoneValidator(String? phone) {
    if (phone!.isEmpty) {
      return 'Phone Number is required';
    } else if (phone.length < 11){
      return 'Phone Number must be 11 characters';
    }
    return null;
  }

  static String? passwordValidator(String? password) {
    if (password!.isEmpty) {
      return 'Password is required';
    } else if (password.length < 8){
      return 'Password must be eight characters or more';
    }
    return null;
  }
}
