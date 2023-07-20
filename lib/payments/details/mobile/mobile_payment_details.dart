import 'package:flutter/material.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/payments/model/payment.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobilePaymentDetailsPage extends StatelessWidget {
  final Payment payment;
  const MobilePaymentDetailsPage({required this.payment, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(),
      body: CustomScrollView(
        slivers: [
          const MobileSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
                delegate: SliverChildListDelegate([
              Text('Payment Details',
                  style: Theme.of(context).textTheme.headlineLarge),
              const Gutter(),
              Text.rich(
                TextSpan(
                  text: 'Id: ',
                  children: <TextSpan>[
                    TextSpan(
                        text: payment.id,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
              const Gutter(),
              Card(
                  child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            Chip(
                                shape: const StadiumBorder(),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                visualDensity: VisualDensity.compact,
                                side: BorderSide.none,
                                avatar: const CircleAvatar(
                                  radius: 10.0,
                                  child: Icon(Icons.person, size: 10.0),
                                ),
                                label: Text(payment.payeeName!)),
                          ],
                        ),
                        Chip(
                          shape: const StadiumBorder(),
                          backgroundColor: payment.status! == PaymentStatus.paid
                              ? Colors.green[500]
                              : payment.status! == PaymentStatus.pending
                                  ? Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            convertDoubleToString(
                              payment.amount!,
                            ),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${Jiffy.parse(payment.paymentDate!).yMMMd} · ${Jiffy.parse(payment.paymentDate!).jm}',
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
                        )
                      ],
                    ),
                    //  const GutterTiny(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Chip(
                                shape: const StadiumBorder(),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                visualDensity: VisualDensity.compact,
                                side: BorderSide.none,
                                avatar: payment.type == PaymentType.hourly
                                    ? const Icon(Icons.timer, size: 14.0)
                                    : payment.type == PaymentType.fixed
                                        ? const Icon(Icons.attach_money,
                                            size: 14.0)
                                        : const Icon(Icons.money_off,
                                            size: 14.0),
                                label: Text(
                                    parseEnumName(payment.type.toString()))),
                          ],
                        ),
                        payment.type == PaymentType.fixed
                            ? Text.rich(
                                TextSpan(
                                    text: 'Milestone: ',
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: payment.milestoneTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium),
                                    ],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              )
                            : Text.rich(
                                TextSpan(
                                    text: '${payment.hours} hrs.',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontWeight: FontWeight.bold)),
                              ),
                      ],
                    ),
                  ],
                ),
              )),
              const Gutter(),
              Text('Project Details',
                  style: Theme.of(context).textTheme.headlineSmall),
              const Gutter(),
              Card(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.projectTitle!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
            ])),
          ),
        ],
      ),
    );
  }
}
