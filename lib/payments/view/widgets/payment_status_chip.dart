import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants.dart';

class PaymentStatusChip extends StatelessWidget {
  final BalanceTransaction balanceTransaction;
  final EdgeInsets? padding;
  const PaymentStatusChip(
      {required this.balanceTransaction, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: const StadiumBorder(),
      backgroundColor: balanceTransaction.status! == 'paid' ||
              balanceTransaction.status! == 'available'
          ? Colors.green[500]
          : balanceTransaction.status! == 'pending' ||
                  balanceTransaction.status! == 'in_transit'
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Colors.red[500],
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      avatar: balanceTransaction.status! == 'paid' ||
              balanceTransaction.status! == 'available'
          ? Icon(
              MdiIcons.checkBold,
              size: 14.0,
              color: Colors.white,
            )
          : balanceTransaction.status! == 'pending' ||
                  balanceTransaction.status! == 'in_transit'
              ? const Icon(
                  Icons.pending,
                  size: 14.0,
                  color: Colors.white,
                )
              : const Icon(
                  Icons.close,
                  size: 14.0,
                  color: Colors.white,
                ),
      label: Text(
        parseEnumName(balanceTransaction.status.toString().capitalize),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
  }
}
