var regex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

class Validators {
  static String? validateField(String? value) {
    if (value!.isEmpty) {
      return "Field cannot be empty";
    } else {
      return null;
    }
  }

  static String? validateAccountNumber(String? str) {
    if (str == null || str.isEmpty) {
      return "Account number cannot be empty";
    } else if (str.length < 10) {
      return "Account number must be 10 digits";
    }
    return null;
  }
    static String? validateBvn(String? str) {
    if (str == null || str.isEmpty) {
      return "Bvn cannot be empty";
    } else if (str.length < 11) {
      return "Bvn must be 11 digits";
    }
    return null;
  }

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email cannot be empty";
    } else if (!regex.hasMatch(email)) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  static String? validatePhonenumber(String? str) {
    RegExp regExp = new RegExp(
      r"^\d{11}$",
    );

    if (!regExp.hasMatch(str!)) {
      return 'Invalid phone number';
    } else {
      return null;
    }
  }

  static String? validateFullName(String? fullName) {
    if (fullName != null && fullName.isEmpty) {
      return 'Fullname field cannot be empty';
    }

    if (fullName != null && fullName.split(' ').length < 2) {
      return 'Fullname field should contain first and last name';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "Password field cannot be empty";
    } else if (value.length < 6) {
      return "Password must be greater than 6 characters";
    } else {
      return null;
    }
  }
}
