import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentsRepository {
  final Stripe _stripe = Stripe.instance;

  /// Initialize Stripe
  void initializeStripe() async {
    Stripe.publishableKey = dotenv.get('STRIPE_PUB_MAG');
    await _stripe.applySettings();
  }

  /// Setup payemnt account for the user
  Future<PaymentIntent> setupPaymentAccount() async {
    return await _stripe.confirmPayment(
        paymentIntentClientSecret: dotenv.get('STRIPE_MAG'));
  }
}
