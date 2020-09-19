class Utils {
  static String getUsername(String email) {
    return email.split("@")[0];
    // test1234@gmail.com -> Test1234
  }

  static String getInitials(String name) {
    List<String> nameSplit = name.split(" ");
    String firstNameInitial = nameSplit[0][0];
    // Rivaan -> R
    String lastNameInitial = nameSplit[1][0];
    // Ranawat -> R
    return firstNameInitial + lastNameInitial;
    // RR
  }
}