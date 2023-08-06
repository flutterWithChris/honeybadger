import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/globals.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';
import 'package:honeybadger/payments/view/widgets/payment_status_chip.dart';

class MobilePaymentDetailsPage extends StatelessWidget {
  final BalanceTransaction balanceTransaction;
  const MobilePaymentDetailsPage({required this.balanceTransaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const GutterSmall(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${parseBalanceTransactionDate(balanceTransaction).yMMMd} · ${parseBalanceTransactionDate(balanceTransaction).jm}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                  ),
                  // Text(
                  //   Jiffy.parse(payment.paymentDate!).jm,
                  //   style: Theme.of(context)
                  //       .textTheme
                  //       .bodyMedium
                  //       ?.copyWith(),
                  // ),
                ],
              ),
              PaymentStatusChip(balanceTransaction: balanceTransaction),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  convertCentsToCurrency(
                    balanceTransaction.net!,
                  ),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              balanceTransaction.description == null
                  ? Container()
                  : Text(balanceTransaction.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                          )),

              // payment.type == PaymentType.fixed
              //     ? Flexible(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.end,
              //           children: [
              //             Icon(MdiIcons.timelineOutline, size: 16.0),
              //             const GutterSmall(),
              //             Text.rich(
              //               TextSpan(
              //                   text: payment.milestoneTitle,
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .bodyMedium),
              //             ),
              //           ],
              //         ),
              //       )
              //     : Flexible(
              //         child: Text.rich(
              //           TextSpan(
              //               text: '${payment.hours} hrs.',
              //               style: Theme.of(context)
              //                   .textTheme
              //                   .bodyMedium
              //                   ?.copyWith()),
              //         ),
              //       ),
            ],
          ),
          // const GutterSmall(),
          // Row(
          //   children: [
          //     Flexible(
          //       child: PopupMenuButton(
          //         offset: const Offset(20.0, 0),
          //         position: PopupMenuPosition.under,
          //         icon: const Icon(Icons.more_vert),
          //         itemBuilder: (context) => [
          //           const PopupMenuItem(
          //             value: 'Refund',
          //             child: Row(
          //               children: [
          //                 Icon(Icons.money_off, size: 16.0),
          //                 GutterSmall(),
          //                 Text('Refund'),
          //               ],
          //             ),
          //           ),
          //         ],
          //         onSelected: (value) {},
          //       ),
          //     ),
          //     //const Gutter(),
          //     Expanded(
          //       flex: 6,
          //       child: FilledButton.icon(
          //           onPressed: () {},
          //           icon: Icon(MdiIcons.archiveEye, size: 16.0),
          //           label: const Text('View Transaction')),
          //     ),
          //     const Spacer(),
          //   ],
          // ),
          const Gutter(),
          Row(
            children: [
              // IconButton(
              //   style: IconButton.styleFrom(
              //     fixedSize: const Size(34, 34),
              //     minimumSize: const Size(34, 34),
              //   ),
              //   icon: const Icon(Icons.copy, size: 16.0),
              //   onPressed: () {},
              // ),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                      ClipboardData(text: balanceTransaction.source!));
                },
                child: Text.rich(
                  TextSpan(
                    text: 'ID: ',
                    children: <TextSpan>[
                      TextSpan(
                          text: balanceTransaction.source!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ],
          ),
          // const GutterTiny(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text('Project Details',
          //       style: Theme.of(context).textTheme.headlineSmall),
          // ),
          // const Gutter(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Text.rich(
          //     TextSpan(
          //       text: 'Project: ',
          //       children: <TextSpan>[
          //         TextSpan(
          //             text: payment.projectTitle,
          //             style: Theme.of(context).textTheme.bodyLarge),
          //       ],
          //       style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          //             fontWeight: FontWeight.bold,
          //           ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PayerChip extends StatelessWidget {
  const PayerChip({
    super.key,
    required this.balanceTransaction,
  });

  final BalanceTransaction balanceTransaction;

  @override
  Widget build(BuildContext context) {
    return Chip(
        shape: const StadiumBorder(),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        visualDensity: VisualDensity.compact,
        side: BorderSide.none,
        avatar: const CircleAvatar(
          radius: 10.0,
          child: Icon(Icons.person, size: 10.0),
        ),
        label: Text(balanceTransaction.source!));
  }
}
