import 'dart:convert';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapchat_proj/data/models/user.dart';

class UserRepository {
  UserRepository() {
    //  _collection = client.getDatabase("snapchat").getCollection("user");
  }
  Future<List<UserModel>> get users => getUsers();
  String baseUrl = 'https://parentstree-server.herokuapp.com/';
  Future<UserModel?> addUser(UserModel user) async {
    String returnData = "";
    UserModel? userAdded;
    String url = "${baseUrl}addUser";
    final Map<String, String> headers = {"Content-type": "application/json"};

    final String json = user.toJsonString();
    final Response response = await post(url, headers: headers, body: json);

    final int statusCode = response.statusCode;
    final String body = response.body;
    if (statusCode == 200) {
      returnData = jsonDecode(body)["createdTokenForUser"];
      userAdded = UserModel.fromJSON(jsonDecode(body)["user"]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', returnData);
    }
    return userAdded;
  }

  Future<UserModel?> isSignedUpUser(
      String usernameOrEmail, String password) async {
    UserModel? user;
    String token = "";
    String url = '${baseUrl}signIn';
    final Map<String, String> headers = {"Content-type": "application/json"};
    final String json =
        '{"login": "$usernameOrEmail", "password": "$password"}';

    final Response response = await post(url, headers: headers, body: json);

    final int statusCode = response.statusCode;

    final String body = response.body;
    if (statusCode == 200) {
      token = jsonDecode(body)["createdTokenForUser"];
      user = UserModel.fromJSON(jsonDecode(body)["user"]);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userToken', token);
    }
    return user;
  }

  Future<bool> isUsernameAviable(String username) async {
    final String url = '${baseUrl}check/name';
    final Map<String, String> headers = {"Content-type": "application/json"};
    final String json = '{"name": "$username"}';

    final Response response = await post(url, headers: headers, body: json);

    final int statusCode = response.statusCode;

    final String body = response.body;

    return statusCode == 200;
  }

  Future<bool> deleteUser() async {
    int statusCode = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('userToken');
    if (userToken != null) {
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userToken
      };
      final String url = '${baseUrl}delete/user';
      Response response = await delete(url, headers: headers);

      // check the status code for the result
      statusCode = response.statusCode;
      prefs.remove('userToken');
    }
    return statusCode == 200;
  }

  Future<bool> isUsedEmail(String email) async {
    String url = '${baseUrl}check/email';
    final Map<String, String> headers = {"Content-type": "application/json"};
    final String json = '{"email": "$email"}';

    final Response response = await post(url, headers: headers, body: json);

    final int statusCode = response.statusCode;

    final String body = response.body;

    return statusCode == 200;
  }

  Future<bool> isUsedPhoneNumber(String phoneNumber) async {
    String url = '${baseUrl}check/phone';
    final Map<String, String> headers = {"Content-type": "application/json"};
    String json = '{"phone": "$phoneNumber"}';

    final Response response = await post(url, headers: headers, body: json);

    final int statusCode = response.statusCode;

    final String body = response.body;

    return !(statusCode == 200);
  }

  Future<List<UserModel>> getUsers() async {
    final Response response = await get('${baseUrl}allUsers');

    final int statusCode = response.statusCode;
    final Map<String, String> headers = response.headers;

    final String? contentType = headers['content-type'];

    final String jsonStr = response.body;

    final parsed = jsonDecode(jsonStr)["users"];
    return parsed
        .map<UserModel>((jsonStr) => UserModel.fromJSON(jsonStr))
        .toList();
  }

  Future<UserModel?> updateUserData(UserModel user) async {
    UserModel? userModelUpdated;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('userToken');
    if (userToken != null) {
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'token': userToken
      };

      String url = '${baseUrl}editAccount';

      String json = user.toJsonString();

      // make POST request
      Response response = await post(url, headers: headers, body: json);

      // check the status code for the result
      int statusCode = response.statusCode;

      // this API passes back the id of the new item added to the body
      String body = response.body;
      final parsed = jsonDecode(body)["user"];
      userModelUpdated = UserModel.fromJSON(parsed);
    }
    return userModelUpdated;
  }
}
