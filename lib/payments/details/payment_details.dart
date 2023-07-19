import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/details/desktop/desktop_payment_details.dart';
import 'package:honeybadger/payments/details/mobile/mobile_payment_details.dart';
import 'package:honeybadger/payments/details/tablet/tablet_payment_details.dart';
import 'package:honeybadger/payments/model/payment.dart';

class PaymentDetailsPage extends StatelessWidget {
  final Payment payment;
  const PaymentDetailsPage({required this.payment, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return DesktopPaymentDetailsPage(payment: payment);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return TabletPaymentDetailsPage(payment: payment);
        } else {
          return MobilePaymentDetailsPage(payment: payment);
        }
      },
    );
  }
}
