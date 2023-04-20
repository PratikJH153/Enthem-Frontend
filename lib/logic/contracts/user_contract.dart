import 'package:enthem2frontend/models/user.dart';

abstract class IUserService {
  String getUserID();
  Future<List<UserModel>> fetchUserList();
  Future<UserModel> getUser(String id);
  Future<int> registerUser(UserModel user);
  Future<bool> checkUserExists(String id);
  Future<bool> updateUser(Map<String, dynamic> user);
  Future<bool> deleteUser(Map<String, dynamic> user);
  Future<bool> addInterests(String id, List<String> interests);
  Future<List<UserModel>> getUsers(List<String> ids);
  Future<bool> checkUsernameExists(String username);
  Future<bool> checkInterestsAdded(String id);

  //SQL
  // Future<UserModel> getUserSQL(String id);
  // Future<bool> registerUserSQL(UserModel user);
  // Future<bool> updateUserSQL(Map<String, dynamic> user);
  // Future<bool> checkUserExistsSQL(String id);
  // Future<bool> deleteUserSQL(String id);
  // Future<bool> addSQLInterests(String id, List<String> interests);
}
