import 'package:flutter/material.dart';
import 'package:honeybadger/payments/model/payment.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../core/constants.dart';

class PaymentStatusChip extends StatelessWidget {
  final Payment payment;
  final EdgeInsets? padding;
  const PaymentStatusChip({required this.payment, this.padding, super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      shape: const StadiumBorder(),
      backgroundColor: payment.status! == PaymentStatus.paid
          ? Colors.green[500]
          : payment.status! == PaymentStatus.pending
              ? Theme.of(context).colorScheme.tertiaryContainer
              : Colors.red[500],
      visualDensity: VisualDensity.compact,
      side: BorderSide.none,
      avatar: payment.status == PaymentStatus.paid
          ? Icon(
              MdiIcons.checkBold,
              size: 14.0,
              color: Colors.white,
            )
          : payment.status == PaymentStatus.pending
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
        parseEnumName(payment.status.toString()),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
  }
}
