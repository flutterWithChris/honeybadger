import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:outsourcedx/payments/model/balance_transaction.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
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

Jiffy parseBalanceTransactionDate(BalanceTransaction balanceTransaction) {
  return Jiffy.parseFromMillisecondsSinceEpoch(
      balanceTransaction.created! * 1000);
}

Jiffy parseDateFromSecondsSinceEpoch(int secondsSinceEpoch) {
  return Jiffy.parseFromMillisecondsSinceEpoch(secondsSinceEpoch * 1000);
}

Future<Size> _getImageSize(String imageUrl, BuildContext context) async {
  final Completer<Size> completer = Completer<Size>();
  final Image image = Image.network(imageUrl);
  image.image
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(Size(
      info.image.width.toDouble(),
      info.image.height.toDouble(),
    ));
  }));
  await precacheImage(image.image, context);
  return completer.future;
}

typedef DebounceCallback = void Function();

class Debouncer {
  Debouncer({required this.interval});

  final Duration interval;

  DebounceCallback? action;

  Timer? _timer;

  void call(DebounceCallback action) {
    action = action;
    _timer?.cancel();
    _timer = Timer(interval, action);
  }

  void _callAction() {
    action?.call();
    _timer = null;
  }

  void reset() {
    action = null;
    _timer = null;
  }
}

// Convert bytes to KB, MB, GB, etc.
String formatBytes(int bytes, int decimals) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  var i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

class OutsourcedFullText extends StatelessWidget {
  const OutsourcedFullText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'OutsourcedX',
      style: GoogleFonts.gloock(),
    );
  }
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
