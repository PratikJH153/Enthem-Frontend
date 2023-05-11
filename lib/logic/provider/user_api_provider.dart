import 'dart:convert';

import 'package:dio/dio.dart';
import '/constants/constants.dart';
import '/logic/contracts/user_contract.dart';
import '/models/user.dart';
import '/services/api_options.dart';
import '/services/debug_console.dart';
import '/utils/encryption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserAPIProvider extends IUserService {
  final Dio _dio = Dio();
  // final UserSQLRepository _userSQLRepository = UserSQLRepository.instance;
  final String _url = '$baseUrl/user';

  static const String filename = "user_api_provider.dart";

  @override
  Future<List<UserModel>> fetchUserList() async {
    try {
      Response response = await _dio.get("$_url/all");
      return response.data["data"].map((e) => UserModel.fromJson(e));
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<int> registerUser(UserModel user) async {
    try {
      final data = json.encode(user.toJson());
      debugData(data.toString(), filename);
      Response response = await _dio.post(
        _url,
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.data != null) {
        return response.statusCode!;
      } else {
        return response.statusCode!;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> checkUserExists(String id) async {
    try {
      final data = json.encode({"id": encrypt(id, dotenv.env["SECRET_KEY"]!)});
      debugData(data.toString(), filename);
      Response response = await _dio.get(
        "$_url/exists",
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<UserModel> getUser(String id) async {
    try {
      final data = json.encode({"id": encrypt(id, dotenv.env["SECRET_KEY"]!)});
      debugData(data.toString(), filename);
      Response response = await _dio.get(
        _url,
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.data != null && response.statusCode != 404) {
        return UserModel.fromJson(response.data["data"]);
      } else if (response.statusCode == 404) {
        throw Exception("User not found!");
      } else {
        throw Exception("Server error");
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> updateUser(Map<String, dynamic> user) async {
    try {
      final data = json.encode(user);
      debugData(data.toString(), filename);
      Response response = await _dio.put(
        _url,
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode != 200) {
        return false;
      } else {
        return true;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> checkUsernameExists(String username) async {
    try {
      final data = json.encode({"username": username});
      debugData(data.toString(), filename);
      Response response = await _dio.get(
        "$_url/usernameexists",
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> deleteUser(Map<String, dynamic> user) async {
    try {
      final data = json.encode(user);
      debugData(data.toString(), filename);
      Response response = await _dio.delete(
        _url,
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> addInterests(String id, List<String> interests) async {
    try {
      final data = json.encode({
        "id": encrypt(id, dotenv.env["SECRET_KEY"]!),
        "interests": interests
      });
      debugData(data.toString(), filename);
      Response response = await _dio.post(
        "$_url/interests",
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  Future<bool> checkInterestsAdded(String id) async {
    try {
      final data = json.encode({"id": encrypt(id, dotenv.env["SECRET_KEY"]!)});
      debugData(data.toString(), filename);
      Response response = await _dio.get(
        "$_url/interests",
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw Error();
      }
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  @override
  String getUserID() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser!.uid;
  }

  @override
  Future<List<UserModel>> getUsers(List<String> ids) async {
    try {
      final data = json.encode({
        "id": ids
            .toSet()
            .toList()
            .map((e) => encrypt(e, dotenv.env["SECRET_KEY"]!))
            .toList(),
      });
      debugData(data.toString(), filename);
      Response response = await _dio.get(
        "$_url/getUserByIds",
        data: data,
        options: getOptions(),
      );
      debugData(response.toString(), filename);
      final userData = response.data;
      final List<UserModel> usersList = [];
      userData["data"]
          .forEach((user) => usersList.add(UserModel.fromJson(user)));
      return usersList;
    } catch (error) {
      debugError(error.toString(), filename);
      rethrow;
    }
  }

  // @override
  // Future<bool> checkUserExistsSQL(String id) async {
  //   try {
  //     final exists = await _userSQLRepository.checkUserExistsSQL(id);
  //     return exists;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }

  // @override
  // Future<bool> deleteUserSQL(String id) async {
  //   try {
  //     final deleted = await _userSQLRepository.deleteUserById(id);
  //     return deleted;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }

  // @override
  // Future<UserModel> getUserSQL(String id) async {
  //   try {
  //     final user = await _userSQLRepository.getUserById(id);
  //     return user!;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }

  // @override
  // Future<bool> registerUserSQL(UserModel user) async {
  //   try {
  //     final userRegistered = await _userSQLRepository.createUser(user);
  //     return userRegistered;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }

  // @override
  // Future<bool> updateUserSQL(Map<String, dynamic> user) async {
  //   try {
  //     final userRegistered =
  //         await _userSQLRepository.updateUser(UserModel.fromJson(user));
  //     return userRegistered;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }

  // @override
  // Future<bool> addSQLInterests(String id, List<String> interests) async {
  //   try {
  //     final data = await _userSQLRepository.addSQLInterests(id, interests);
  //     return data;
  //   } catch (error) {
  //     debugError(error.toString(), filename);
  //     rethrow;
  //   }
  // }
}
