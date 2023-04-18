import 'package:enthem2frontend/logic/contracts/user_contract.dart';
import 'package:enthem2frontend/logic/provider/user_api_provider.dart';
import 'package:enthem2frontend/models/user.dart';

class UserAPIRepository extends IUserService {
  final _provider = UserAPIProvider();

  @override
  Future<List<UserModel>> fetchUserList() async {
    return await _provider.fetchUserList();
  }

  @override
  Future<int> registerUser(UserModel user) async {
    return await _provider.registerUser(user);
  }

  @override
  Future<bool> checkUserExists(String id) async {
    return await _provider.checkUserExists(id);
  }

  @override
  Future<UserModel> getUser(String id) async {
    return await _provider.getUser(id);
  }

  @override
  Future<bool> updateUser(Map<String, dynamic> user) async {
    return await _provider.updateUser(user);
  }

  @override
  Future<bool> checkUsernameExists(String username) async {
    return await _provider.checkUsernameExists(username);
  }

  @override
  Future<bool> deleteUser(Map<String, dynamic> user) async {
    return await _provider.deleteUser(user);
  }

  @override
  Future<bool> addInterests(String id, List<String> interests) async {
    return await _provider.addInterests(id, interests);
  }

  @override
  Future<bool> checkInterestsAdded(String id) async {
    return await _provider.checkInterestsAdded(id);
  }

  @override
  String getUserID() {
    return _provider.getUserID();
  }

  @override
  Future<List<UserModel>> getUsers(List<String> ids) {
    return _provider.getUsers(ids);
  }

  @override
  Future<bool> checkUserExistsSQL(String id) {
    return _provider.checkUserExistsSQL(id);
  }

  @override
  Future<bool> deleteUserSQL(String id) {
    return _provider.deleteUserSQL(id);
  }

  @override
  Future<UserModel> getUserSQL(String id) {
    return _provider.getUserSQL(id);
  }

  @override
  Future<bool> registerUserSQL(UserModel user) {
    return _provider.registerUserSQL(user);
  }

  @override
  Future<bool> updateUserSQL(Map<String, dynamic> user) {
    return _provider.updateUserSQL(user);
  }

  @override
  Future<bool> addSQLInterests(String id, List<String> interests) {
    return _provider.addSQLInterests(id, interests);
  }

  @override
  Future<bool> checkInterestsSQLAdded(String id) {
    return _provider.checkInterestsAdded(id);
  }
}

class NetworkError extends Error {}
