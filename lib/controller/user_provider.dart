import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel _user = UserModel(
    username: 'username',
    uid: 'uid',
    email: 'email',
    bio: 'bio',
    photoUrl: 'photoUrl',
    follower: [],
    following: [],
    status: 'status',
  );
  final AuthMethods _authMethods = AuthMethods();
  UserModel get user => _user;

  refreshUser() async {
    UserModel userModel = await _authMethods.getUserDetails();
    _user = userModel;
    notifyListeners();
  }

  getUserData(BuildContext context) async {
    UserProvider userProvider = Provider.of(context, listen: false)
      ..refreshUser();
    await userProvider.refreshUser();
  }
}
