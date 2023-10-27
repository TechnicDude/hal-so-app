class AppValidator {
  static String? emailValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange e-postadress  ";
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-_]+\.[a-zA-Z]+")
        .hasMatch(value.trim())) {
      return "vänligen ange en giltig e-postadress";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "Vänligen ange ditt lösenord";
    } else if (value.length < 7) {
      return "lösenord måste vara minst 7 tecken långt";
    }
    return null;
  }

  static String? confirm_passwordValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange bekräfta lösenord ";
    } else if (value.length < 5) {
      return "lösenordet måste vara detsamma";
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange ditt förnamn ";
    } else if (value.length < 3) {
      return "vänligen ange minst 3 tecken långa";
    }
    return null;
  }

  static String? lastnameValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange ditt efternamn";
    } else if (value.length < 3) {
      return "vänligen ange minst 3 tecken långah";
    }
    return null;
  }

  static String? mobileValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange telefonnummer ";
    } else if (value.length < 6 || value.length > 11) {
      return "ange ett giltigt telefonnummer";
    }
    return null;
  }

  static String? currentpasswordValidator(String? value) {
    if (value!.isEmpty) {
      return "vänligen ange ditt nuvarande lösenord";
    } else if (value.length < 5) {
      return "lösenordet måste vara detsamma";
    }
    return null;
  }

  static String? emptyValidator(String? value) {
    if (value!.isEmpty) {
      return "skriv in lite text ";
    }
    return null;
  }

  static String? emptyfieldValidator(String? value) {
    if (value!.isEmpty) {
      return "Detta fält får inte vara tomt ";
    }
    return null;
  }
}
