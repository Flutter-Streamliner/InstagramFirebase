import 'package:flutter_instagram/models/models.dart';
import 'package:meta/meta.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<List<User>> searchUsers({@required String query});
}
