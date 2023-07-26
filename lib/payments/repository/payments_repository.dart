import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/model/stripe_account.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PaymentsRepository {
  final Stripe _stripe = Stripe.instance;

  /// Initialize Stripe
  void initializeStripe() async {
    Stripe.publishableKey = kIsWeb
        ? const String.fromEnvironment('STRIPE_PUB_MAG')
        : dotenv.get('STRIPE_PUB_MAG');
    await _stripe.applySettings();
  }

  Future<void> _openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Fetch stripe account
  Future<StripeAccount> fetchStripeAccount(String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeAccount'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      return StripeAccount.fromJson(jsonResponse['account']);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Setup payemnt account for the user
  Future<String> setupPaymentAccount(BuildContext context,
      {required String email, required String userId}) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/createStripeConnectAccount'),
          body: {
            'country': 'US',
            'email': email,
            'userId': userId,
          });

      final jsonResponse = jsonDecode(response.body);
      print('Response: $jsonResponse');
      String accountLinkUrl = jsonResponse['url'];

      String accountId =
          jsonResponse['accountId']; // This is the Stripe account ID

      if (await canLaunchUrl(Uri.parse(accountLinkUrl))) {
        await launchUrl(Uri.parse(accountLinkUrl),
            mode: LaunchMode.externalApplication);
      } else {
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Error starting Stripe Connect setup!',
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 2),
          ),
        );
        throw 'Could not launch $accountLinkUrl';
      }

      return accountId;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Initialize payment sheet
  Future<void> initPaymentSheet(context,
      {required String email,
      required double amount,
      required String freelancerStripeId}) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'amount': (amount * 100).toString(),
            'email': email,
            'freelancerStripeId': freelancerStripeId,
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: jsonResponse['paymentIntent'],
        merchantDisplayName: 'Honeybadger',
        customerId: jsonResponse['customer'],
        customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
        style: Theme.of(context).brightness == Brightness.dark
            ? ThemeMode.dark
            : ThemeMode.light,
      ));

      await Stripe.instance.presentPaymentSheet();

      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Payment Successful!'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      log(e.toString());
      if (e is StripeException) {
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text(
              e.error.localizedMessage!,
              style: const TextStyle(color: Colors.white),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            content: Text('Error: ${e.toString()}',
                style: const TextStyle(color: Colors.white)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
