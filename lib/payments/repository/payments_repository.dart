import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:OutsourcedX/core/constants.dart';
import 'package:OutsourcedX/payments/model/balance.dart';
import 'package:OutsourcedX/payments/model/balance_transaction.dart';
import 'package:OutsourcedX/payments/model/charge.dart';
import 'package:OutsourcedX/payments/model/stripe_account.dart';
import 'package:OutsourcedX/payouts/model/payout.dart';
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
  Future<StripeAccount?> fetchStripeAccount(String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeAccount'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse['account'].toString());
      return StripeAccount.fromJson(jsonResponse['account']);
    } catch (e) {
      log('**Error fetching stripe account: ${e.toString()}**');
      return null;
    }
  }

  Future<void> finishStripeConnectOnboarding(String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeConnectOnboardingLink'),
          body: {
            'stripeAccountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      String accountLinkUrl = jsonResponse['url'];

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
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<String> getLoginLink(String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/createStripeLoginLink'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      return jsonResponse['url'];
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
  Future<String?> initPaymentSheet(context,
      {required String email,
      required int amount,
      required int applicationFeeAmount,
      required String freelancerStripeAccountId,
      required String description,
      required Map<String, dynamic> metadata}) async {
    print('Metadata: ${jsonEncode(metadata)}');
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/stripePaymentIntentRequest'),
          body: {
            'amount': (amount * 100).toString(),
            'email': email,
            'description': description,
            'freelancerStripeAccountId': freelancerStripeAccountId,
            'applicationFeeAmount': (applicationFeeAmount * 100).toString(),
            // 'metadata': jsonEncode(metadata),
          });

      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());

      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US', testEnv: true),
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
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          content: Text('Payment Successful!',
              style: TextStyle(color: Colors.white)),
          duration: Duration(seconds: 2),
        ),
      );

      // return customer
      return jsonResponse['customer'];
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
      rethrow;
    }
  }

  Future<Balance> getBalance(String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeBalance'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      return Balance.fromJson(jsonResponse['balance']);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BalanceTransaction>> getBalanceTransactions(
      String stripeAccountId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeBalanceTransactions'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      var transactions = jsonResponse['balance_transactions']['data'] as List;
      List<BalanceTransaction> transactionsList =
          transactions.map((i) => BalanceTransaction.fromJson(i)).toList();
      return transactionsList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<BalanceTransaction>> getBalanceTransactionsPaginated(
      String stripeAccountId, String startingAfterTransactionId) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeBalanceTransactionsPaginated'),
          body: {
            'accountId': stripeAccountId,
            'startingAfter': startingAfterTransactionId
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      var transactions = jsonResponse['transactions'] as List;
      List<BalanceTransaction> transactionsList =
          transactions.map((i) => BalanceTransaction.fromJson(i)).toList();
      return transactionsList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Charge>> getCharges({required String stripeAccountId}) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeCharges'),
          body: {
            'accountId': stripeAccountId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      var charges = jsonResponse['charges']['data'] as List;
      List<Charge> chargesList =
          charges.map((i) => Charge.fromJson(i)).toList();
      return chargesList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<List<Charge>> getChargesPaginated(
      {required String stripeAccountId,
      required String startingAfterId}) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/getStripeCharges'),
          body: {
            'accountId': stripeAccountId,
            'startingAfter': startingAfterId,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      var charges = jsonResponse['charges']['data'] as List;
      List<Charge> chargesList =
          charges.map((i) => Charge.fromJson(i)).toList();
      return chargesList;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  /// Payout
  Future<Payout> requestPayout(
      {required String stripeAccountId,
      required int amount,
      required PayoutMethod payoutMethod}) async {
    try {
      final response = await http.post(
          Uri.parse(
              'https://us-central1-honeybadger-817ee.cloudfunctions.net/createStripePayout'),
          body: {
            'accountId': stripeAccountId,
            'amount': amount.toString(),
            'method': payoutMethod.toString().split('.').last,
          });
      print(response.body);
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse.toString());
      print(jsonResponse.toString());
      return Payout.fromJson(jsonResponse);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
