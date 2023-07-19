import 'package:uuid/uuid.dart';

String generateUniqueId() {
  var uuid = const Uuid();
  return uuid.v4();
}
