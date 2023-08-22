import 'package:OutsourcedX/profile/model/user.dart';
import 'package:image_picker/image_picker.dart';

abstract class BaseUserRepository {
  Future<User?> getUser(User user);
  Future<Stream<User>> getUserAsStream(User user);
  Future<void> updateUser(User user);
  Future<void> deleteUser(User user);
  Future<void> createUser(User user);
  Future<String?> setUserProfilePicture(XFile profilePicture, User user);
}
