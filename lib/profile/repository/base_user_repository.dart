import 'package:honeybadger/profile/model/user.dart';
import 'package:image_picker/image_picker.dart';

abstract class BaseUserRepository {
  Future<User> getUser(String userId);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
  Future<void> createUser(User user);
  Future<String?> setUserProfilePicture(XFile profilePicture, User user);
}
