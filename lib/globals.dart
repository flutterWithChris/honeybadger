import 'package:uuid/uuid.dart';
import 'package:jose/jose.dart';

String generateUniqueId() {
  var uuid = const Uuid();
  return uuid.v4();
}

String generateToken(String userId) {
  var claims = JsonWebTokenClaims.fromJson({
    'user_id': userId,
  });

  var builder = JsonWebSignatureBuilder()
    ..jsonContent = claims.toJson()
    ..setProtectedHeader('alg', 'HS256')
    ..addRecipient(
        JsonWebKey.fromJson({'kty': 'oct', 'k': 'YOUR_STREAM_SECRET'}));

  var jws = builder.build();
  return jws.toCompactSerialization();
}
