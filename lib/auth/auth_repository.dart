import 'dart:convert';

import 'package:nagp_quiz/common/json_util.dart';
import 'package:nagp_quiz/models/dto/user.dart';

import '../stores/quiz_store.dart';

class AuthRepository {
  String userKey = "userListstKey";
  String currentUserKey = "currentUsersKey";

  Future<User?> login(data) async {
    var userList = await loadUserAsync();
    var authUser = userList.where((element) =>
        element.mobileNumber == data.mobileNumber &&
        element.password == data.password);
    if (authUser.isNotEmpty) {
      var userJson = jsonEncode(authUser.toList());
      QuizStore.prefs!.setString(currentUserKey, userJson);
    }
    return authUser.isNotEmpty ? authUser.first : null;
  }

  Future<User> loadCurrentUserAsync() async {
    List<User> currentUser = [];
    var userJson = QuizStore.prefs!.getString(currentUserKey);
    if (userJson != null) {
      currentUser = await JsonUtil.loadFromJsonStringAsync<User>(
          userJson, User.jsonToObject);
    }

    return currentUser.first;
  }

  Future<void> register(data) async {
    User user = User(data.username, data.email, data.password,
        data.mobileNumber, data.image);
    var userList = await loadUserAsync();
    userList.add(user);

    var userJson = jsonEncode(userList);
    QuizStore.prefs!.setString(userKey, userJson);
  }

  Future<List<User>> loadUserAsync() async {
    List<User> userList = [];
    var userJson = QuizStore.prefs!.getString(userKey);
    if (userJson != null) {
      userList = await JsonUtil.loadFromJsonStringAsync<User>(
          userJson, User.jsonToObject);
      userList = userList.reversed.toList();
    }
    return userList;
  }

  static logOutUser() async {
    await QuizStore.prefs!.clear();
  }
}
