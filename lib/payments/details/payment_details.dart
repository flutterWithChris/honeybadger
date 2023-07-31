import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/details/desktop/desktop_payment_details.dart';
import 'package:honeybadger/payments/details/mobile/mobile_payment_details.dart';
import 'package:honeybadger/payments/details/tablet/tablet_payment_details.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';

class PaymentDetailsPage extends StatelessWidget {
  final BalanceTransaction balanceTransaction;
  const PaymentDetailsPage({required this.balanceTransaction, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return DesktopPaymentDetailsPage(
              balanceTransaction: balanceTransaction);
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return TabletPaymentDetailsPage(
              balanceTransaction: balanceTransaction);
        } else {
          return MobilePaymentDetailsPage(
              balanceTransaction: balanceTransaction);
        }
      },
    );
  }
}
