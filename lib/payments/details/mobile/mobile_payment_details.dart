import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/globals.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';
import 'package:honeybadger/payments/view/widgets/payment_status_chip.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobilePaymentDetailsPage extends StatelessWidget {
  final BalanceTransaction balanceTransaction;
  const MobilePaymentDetailsPage({required this.balanceTransaction, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Text('Payment Details',
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gutter(),
              Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(),
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
                        PaymentStatusChip(
                            balanceTransaction: balanceTransaction),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                              convertCentsToCurrency(
                                balanceTransaction.amount!,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
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

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'From: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            PayerChip(
                              balanceTransaction: balanceTransaction,
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Chip(
                        //         shape: const StadiumBorder(),
                        //         backgroundColor:
                        //             Theme.of(context).scaffoldBackgroundColor,
                        //         visualDensity: VisualDensity.compact,
                        //         side: BorderSide.none,
                        //         avatar: payment.type == PaymentType.hourly
                        //             ? const Icon(Icons.timer, size: 14.0)
                        //             : payment.type == PaymentType.fixed
                        //                 ? const Icon(Icons.attach_money,
                        //                     size: 14.0)
                        //                 : const Icon(Icons.money_off,
                        //                     size: 14.0),
                        //         label: Text(
                        //             parseEnumName(payment.type.toString()))),
                        //   ],
                        // ),
                      ],
                    ),
                    //  const GutterTiny(),
                  ],
                ),
              )),
              const Gutter(),
              Row(
                children: [
                  Flexible(
                    child: PopupMenuButton(
                      offset: const Offset(20.0, 0),
                      position: PopupMenuPosition.under,
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'Refund',
                          child: Row(
                            children: [
                              Icon(Icons.money_off, size: 16.0),
                              GutterSmall(),
                              Text('Refund'),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {},
                    ),
                  ),
                  //const Gutter(),
                  Expanded(
                    flex: 6,
                    child: FilledButton.tonalIcon(
                        onPressed: () {},
                        icon: Icon(MdiIcons.fileEye, size: 16.0),
                        label: const Text('View Invoice')),
                  ),
                  const Spacer(),
                ],
              ),
              const GutterTiny(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0),
                child: Row(
                  children: [
                    // IconButton(
                    //   style: IconButton.styleFrom(
                    //     fixedSize: const Size(34, 34),
                    //     minimumSize: const Size(34, 34),
                    //   ),
                    //   icon: const Icon(Icons.copy, size: 16.0),
                    //   onPressed: () {},
                    // ),
                    TextButton(
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: balanceTransaction.id!));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Row(
                              children: [
                                Icon(Icons.copy_outlined,
                                    size: 16.0,
                                    color: Theme.of(context)
                                        .snackBarTheme
                                        .actionTextColor),
                                const GutterSmall(),
                                const Text('ID Copied to clipboard'),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'ID: ',
                          children: <TextSpan>[
                            TextSpan(
                                text: balanceTransaction.id,
                                style: Theme.of(context).textTheme.bodySmall),
                          ],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ],
                ),
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
            ])),
          ),
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
