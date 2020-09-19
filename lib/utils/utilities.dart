class Utils {
  static String getUsername(String email) {
    return email.split("@")[0];
    // test1234@gmail.com -> Test1234
  }
}