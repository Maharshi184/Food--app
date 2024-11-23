// user_data.dart
class UserData {
  static final UserData _instance = UserData._internal();

  // Variables to store user data
  Map<String, dynamic>? user;

  // Private constructor
  UserData._internal();

  // Singleton instance accessor
  static UserData get instance => _instance;

  // Method to set user data
  void setUser(Map<String, dynamic> userData) {
    user = userData;
  }

  // Method to get user data
  Map<String, dynamic>? getUser() {
    return user;
  }

  // Clear user data
  void clearUser() {
    user = null;
  }
}
