import 'package:outsourcedx/core/presentation/drawers/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/core/extensions.dart';
import 'package:outsourcedx/core/presentation/system/main_navigation_bar.dart';
import 'package:outsourcedx/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:outsourcedx/payments/bloc/payments_bloc.dart';
import 'package:outsourcedx/payments/details/payment_details.dart';
import 'package:outsourcedx/payouts/bloc/payout_bloc.dart';
import 'package:outsourcedx/payouts/model/payout.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../model/balance_transaction.dart';

class MobilePaymentsPage extends StatefulWidget {
  const MobilePaymentsPage({super.key});

  @override
  State<MobilePaymentsPage> createState() => _MobilePaymentsPageState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  // TODO: implement context
  BuildContext get context => throw UnimplementedError();

  @override
  void deactivate() {
    // TODO: implement deactivate
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
  }

  @override
  void didUpdateWidget(covariant StatefulWidget oldWidget) {
    // TODO: implement didUpdateWidget
  }

  @override
  void initState() {
    // TODO: implement initState
  }

  @override
  // TODO: implement mounted
  bool get mounted => throw UnimplementedError();

  @override
  void reassemble() {
    // TODO: implement reassemble
  }

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
  }

  @override
  // TODO: implement widget
  StatefulWidget get widget => throw UnimplementedError();
}

class _MobilePaymentsPageState extends State<MobilePaymentsPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        drawer: const MainDrawer(),
        body: RefreshIndicator(
          // header: const ClassicHeader(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   hapticFeedback: true,
          //   triggerOffset: 70.0,
          //   clamping: false,

          // ),
          // spring:
          //     const SpringDescription(mass: 60, stiffness: 100, damping: 500),
          onRefresh: () async {
            context.read<PaymentsBloc>().add(LoadBalanceAndTransactions(
                user: context.read<ProfileBloc>().state.user!));
          },
          child: CustomScrollView(
            slivers: [
              MobileSliverAppBar(
                iconOnly: true,
              ),
              BlocBuilder<PaymentsBloc, PaymentsState>(
                builder: (context, state) {
                  if (state.stripeAccountStatus ==
                      StripeAccountStatus.notCreated) {
                    // Create not setup page
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.money_off,
                                  size: 72.0,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey[500]
                                      : Colors.grey[600]),
                              const Gutter(),
                              Text('You have not setup payments yet.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.grey[500]
                                              : Colors.grey[600])),
                              const Gutter(),
                              Row(
                                children: [
                                  Expanded(
                                    child: FilledButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.payments,
                                          size: 14.0,
                                        ),
                                        label: const Text(
                                          'Setup Payments',
                                        )),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is PaymentsLoaded && state.loginLink != null) {
                    var availableBalance = 0;
                    if (state.balance?.available != null) {
                      availableBalance = state.balance!.available!
                          .map((e) => e.amount!)
                          .reduce((value, element) => value + element);
                    }
                    // if (availableBalance > 0) {
                    // showBottomSheet(
                    //     context: context,
                    //     builder: (context) {
                    //       return Container(
                    //         height: 200,
                    //         color: Colors.amber,
                    //         child: Center(
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.center,
                    //             mainAxisSize: MainAxisSize.min,
                    //             children: <Widget>[
                    //               const Text('BottomSheet'),
                    //               ElevatedButton(
                    //                 child: const Text('Close BottomSheet'),
                    //                 onPressed: () => Navigator.pop(context),
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       );
                    //     },
                    //   );
                    // }

                    var pendingBalance = 0;

                    if (state.balance?.pending != null) {
                      pendingBalance = state.balance!.pending!
                          .map((e) => e.amount!)
                          .reduce((value, element) => value + element);
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text(
                                    'Balance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                            ),
                            const GutterSmall(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Available: ',
                                      children: [
                                        TextSpan(
                                          text: convertCentsToCurrency(
                                              availableBalance),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gutter(),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Pending: ',
                                      children: [
                                        TextSpan(
                                          text: convertCentsToCurrency(
                                              pendingBalance),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gutter(),
                            availableBalance > 0
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                            child: IconButton.filled(
                                                onPressed: () {},
                                                icon: const Icon(
                                                    Icons.dashboard))),
                                        const Gutter(),
                                        Expanded(
                                          flex: 7,
                                          child: FilledButton.icon(
                                              onPressed: () {
                                                showBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return PayoutMethodSheet(
                                                      availableBalance:
                                                          availableBalance,
                                                    );
                                                  },
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.payments,
                                                size: 14.0,
                                              ),
                                              label: Text(
                                                'Payout ${convertCentsToCurrency(availableBalance)}',
                                              )),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                  )
                                : FractionallySizedBox(
                                    widthFactor: 0.8,
                                    child: FilledButton.icon(
                                        style: state.stripeAccount
                                                    ?.payoutsEnabled ==
                                                false
                                            ? FilledButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white)
                                            : null,
                                        onPressed: () {
                                          launchUrlString(state.loginLink!,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        },
                                        icon: Icon(
                                            state.stripeAccount
                                                        ?.payoutsEnabled ==
                                                    false
                                                ? Icons.error_rounded
                                                : Icons.dashboard,
                                            size: 20.0),
                                        label: const Text('View Dashboard')),
                                  ),
                            state.stripeAccount?.payoutsEnabled == false
                                ? Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16.0, 8.0, 16.0, 0.0),
                                    child: Card(
                                      elevation: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant,
                                      child: const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Text.rich(
                                          TextSpan(
                                              text:
                                                  'Payouts are currently disabled on your account! ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        ' Please visit the dashboard to fix any issues.',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ))
                                              ]),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is PaymentsLoaded &&
                      state.stripeAccountStatus ==
                          StripeAccountStatus.complete &&
                      state.loginLink == null) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      sliver: SliverToBoxAdapter(
                        child: FractionallySizedBox(
                          widthFactor: 0.8,
                          child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                context.read<PaymentsBloc>().add(
                                      LoadPayments(
                                          user: context
                                              .read<ProfileBloc>()
                                              .state
                                              .user!),
                                    );
                              },
                              icon: const Icon(Icons.error_rounded, size: 20.0),
                              label: const Text('Refresh Dashboard')),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(
                    child: SizedBox(),
                  );
                },
              ),
              BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, paymentsState) {
                if (paymentsState is PaymentsError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            MdiIcons.alertCircleOutline,
                            size: 72.0,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                          ),
                          const Gutter(),
                          Text(paymentsState.message),
                          const Gutter(),
                          FilledButton(
                            onPressed: () => context.read<PaymentsBloc>().add(
                                LoadPayments(
                                    user: context
                                        .read<ProfileBloc>()
                                        .state
                                        .user!)),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (paymentsState is PaymentsLoading ||
                    paymentsState is PaymentsInitial) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  );
                }
                if (paymentsState is PaymentsLoaded &&
                    paymentsState.stripeAccountStatus ==
                        StripeAccountStatus.complete) {
                  if (paymentsState.balanceTransactions == null ||
                      paymentsState.balanceTransactions!.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 100.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.rocketLaunchOutline,
                                size: 72.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600]),
                            const Gutter(),
                            Text('Zero Today, Hero Tomorrow.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.grey[500]
                                            : Colors.grey[600])),
                          ],
                        ),
                      ),
                    );
                  }
                  if (paymentsState.balanceTransactions != null &&
                      paymentsState.balanceTransactions!.isNotEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            DateTime availableDate =
                                Jiffy.parseFromMillisecondsSinceEpoch(
                                        paymentsState.balanceTransactions![0]
                                                .availableOn! *
                                            1000)
                                    .dateTime;

                            String transactionType =
                                paymentsState.balanceTransactions![0].type!;
                            if (transactionType == 'transfer') {
                              transactionType = 'Payment';
                            }

                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index == 0) const Divider(),
                                FreelancerBalanceTransactionTile(
                                    balanceTransaction: paymentsState
                                        .balanceTransactions![index],
                                    transactionType: transactionType,
                                    availableDate: availableDate),
                              ],
                            );
                          },
                          childCount: paymentsState.balanceTransactions!.length,
                        ),
                      ),
                    );
                  } else if (paymentsState.stripeAccountStatus ==
                      StripeAccountStatus.incomplete) {
                    List<dynamic> missingRequirements = paymentsState
                        .stripeAccount!
                        .requirements!['currently_due'] as List<dynamic>;
                    // TOS CHECK
                    if (missingRequirements
                        .any((element) => element == 'tos_acceptance.date')) {
                      missingRequirements.remove('tos_acceptance.date');
                      if (missingRequirements.any((element) =>
                              element == 'terms_of_service_agreement') ==
                          false) {
                        missingRequirements.add('terms_of_service_agreement');
                      }
                    }
                    if (missingRequirements
                        .any((element) => element == 'tos_acceptance.ip')) {
                      missingRequirements.remove('tos_acceptance.ip');
                      if (missingRequirements.any((element) =>
                              element == 'terms_of_service_agreement') ==
                          false) {
                        missingRequirements.add('terms_of_service_agreement');
                      }
                    }
                    if (missingRequirements
                        .any((element) => element == 'external_account')) {
                      missingRequirements.remove('external_account');
                      missingRequirements.add('payout_account_details');
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.puzzle,
                                size: 72.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                              ),
                              const Gutter(),
                              const Text.rich(
                                TextSpan(
                                  text: 'Your Stripe account is incomplete.',
                                  children: [
                                    TextSpan(
                                      text:
                                          ' Please complete your payment account to receive payments.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Gutter(),
                              FilledButton.icon(
                                onPressed: () => context
                                    .read<PaymentsBloc>()
                                    .add(FinishSetupPaymentAccount(
                                        user: context
                                            .read<ProfileBloc>()
                                            .state
                                            .user!,
                                        context: context)),
                                icon: const Icon(
                                  Icons.flag_rounded,
                                  size: 16.0,
                                ),
                                label: const Text('Finish Setup'),
                              ),
                              const Gutter(),
                              SizedBox(
                                width: double.infinity,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      children: [
                                        Text('Missing Requirements: ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                        const GutterTiny(),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            for (dynamic requirement
                                                in missingRequirements)
                                              Wrap(
                                                spacing: 8.0,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                children: [
                                                  Icon(
                                                      Icons
                                                          .check_circle_outline_rounded,
                                                      size: 14.0,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Colors.grey[500]
                                                          : Colors.grey[600]),
                                                  Text(requirement
                                                      .toString()
                                                      .replaceAll('_', ' ')
                                                      .replaceAll('.', ': ')
                                                      .toTitleCase()),
                                                ],
                                              )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  //else if (state is PaymentsLoaded && paymentsState.stripeAccountStatus == StripeAccountStatus.pending){}
                  else if (paymentsState.stripeAccountStatus ==
                      StripeAccountStatus.notCreated) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                MdiIcons.alertCircleOutline,
                                size: 72.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600],
                              ),
                              const Gutter(),
                              const Text(
                                'You haven\'t yet setup your Stripe account!\nDon\'t worry it doesn\'t take too long.',
                                textAlign: TextAlign.center,
                              ),
                              const Gutter(),
                              FilledButton.icon(
                                onPressed: () => context
                                    .read<PaymentsBloc>()
                                    .add(SetupPaymentAccount(
                                        user: context
                                            .read<ProfileBloc>()
                                            .state
                                            .user!,
                                        context: context)),
                                icon: const Icon(
                                  FontAwesomeIcons.stripeS,
                                  size: 16.0,
                                ),
                                label: const Text('Setup Stripe Account'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
                return const SliverFillRemaining(
                    child: Center(
                  child: Text('Something Went Wrong...'),
                ));
              }),
              // SliverToBoxAdapter(
              //   child: FractionallySizedBox(
              //     widthFactor: 0.8,
              //     child: FilledButton.icon(
              //         style: context
              //                     .read<PaymentsBloc>()
              //                     .state
              //                     .stripeAccount
              //                     ?.payoutsEnabled ==
              //                 false
              //             ? FilledButton.styleFrom(
              //                 backgroundColor: Colors.red,
              //                 foregroundColor: Colors.white)
              //             : null,
              //         onPressed: () {
              //           context.read<PaymentsBloc>().add(SendPayment(
              //               client: User(
              //                 id: '123456789',
              //                 firstName: 'Billy',
              //                 lastName: 'Conforto',
              //                 email: 'billy@email.com',
              //                 stripeAccountId: 'acct_1NYeAV4JF4nBzb2w',
              //               ),
              //               freelancer: context.read<ProfileBloc>().state.user!,
              //               proposal: Proposal(
              //                 id: '17382673',
              //                 jobName: 'Build a hydration tracking app.',
              //               ),
              //               context: context));
              //         },
              //         icon: Icon(
              //             context
              //                         .read<PaymentsBloc>()
              //                         .state
              //                         .stripeAccount
              //                         ?.payoutsEnabled ==
              //                     false
              //                 ? Icons.error_rounded
              //                 : Icons.dashboard,
              //             size: 20.0),
              //         label: const Text('Test Payment')),
              //   ),
              // ),
            ],
          ),
        ));
  }
}

class FreelancerBalanceTransactionTile extends StatelessWidget {
  const FreelancerBalanceTransactionTile({
    super.key,
    required this.balanceTransaction,
    required this.transactionType,
    required this.availableDate,
  });

  final BalanceTransaction balanceTransaction;
  final String transactionType;
  final DateTime availableDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: ListTile(
              onTap: () {
                // context.go(
                //     '/payments/details/${paymentsState.balanceTransactions![index].id}',
                //     extra: paymentsState
                //         .balanceTransactions![index]);
                showBottomSheet(
                    enableDrag: true,
                    context: context,
                    builder: (context) => DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.21,
                          minChildSize: 0.2,
                          builder: (context, scrollController) =>
                              PaymentDetailsPage(
                                  balanceTransaction: balanceTransaction),
                        ));
              },
              leading: balanceTransaction.status == 'available' ||
                      balanceTransaction.status == 'paid'
                  ? Icon(
                      MdiIcons.checkBold,
                      size: 20.0,
                      color: Colors.green,
                    )
                  : balanceTransaction.status == 'pending' ||
                          balanceTransaction.status == 'in_transit'
                      ? const Icon(
                          Icons.pending,
                          size: 20.0,
                          color: Colors.grey,
                        )
                      : const Icon(
                          Icons.close,
                          size: 20.0,
                          color: Colors.red,
                        ),
              title: Row(
                children: [
                  Text(transactionType.replaceAll('_', ' ').toTitleCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const GutterSmall(),
                ],
              ),
              subtitle: balanceTransaction.description != null
                  ? Text(balanceTransaction.description!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[500]
                                  : Colors.grey[600]))
                  : null,
              // TODO: Add payment status widge
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    convertCentsToCurrency(balanceTransaction.net!),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        // color:
                        //     Theme.of(context).brightness ==
                        //             Brightness.light
                        //         ? Colors.grey[500]
                        //         : Colors.grey[600],
                        ),
                  ),
                  const GutterTiny(),
                  Text(
                    Jiffy.parseFromMillisecondsSinceEpoch(
                            balanceTransaction.created! * 1000)
                        .fromNow(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.grey[500]
                            : Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class PayoutMethodSheet extends StatefulWidget {
  final int availableBalance;
  const PayoutMethodSheet({
    required this.availableBalance,
    super.key,
  });

  @override
  State<PayoutMethodSheet> createState() => _PayoutMethodSheetState();
}

class _PayoutMethodSheetState extends State<PayoutMethodSheet> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: context.watch<PayoutBloc>().state is PayoutStarted
          ? 0.26
          : context.watch<PayoutBloc>().state is PayoutInitial
              ? 0.24
              : 0.2,
      minChildSize: 0.2,
      builder: (context, controller) => BlocConsumer<PayoutBloc, PayoutState>(
        listener: (context, state) {
          if (state is PayoutSuccess) {
            context.read<PaymentsBloc>().add(LoadBalanceAndTransactions(
                user: context.read<ProfileBloc>().state.user!));
          }
          if (state is PayoutFailure) {}
        },
        builder: (context, state) {
          if (state is PayoutLoading) {
            return Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 24.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Processing Payout...',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Gutter(),
                      const LinearProgressIndicator(),
                    ],
                  ),
                ));
          }
          if (state is PayoutFailure) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_rounded,
                          color: Colors.red, size: 24.0),
                      const Gutter(),
                      Text(
                        'Payout Failed',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const GutterSmall(),
                  const Row(
                    children: [
                      Text('There was an issue processing your payout.'),
                    ],
                  ),
                  const Gutter(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white),
                          onPressed: () {
                            context.read<PayoutBloc>().add(RequestPayout(
                                user: state.user!,
                                amountInCents: state.amountInCents!,
                                payoutMethod: state.payoutMethod!));
                          },
                          icon: const Icon(Icons.refresh_rounded, size: 20.0),
                          label: const Text('Retry'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          if (state is PayoutSuccess) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded,
                          color: Colors.green, size: 24.0),
                      const Gutter(),
                      Text(
                        'Payout Sent',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  const GutterSmall(),
                  const Row(
                    children: [
                      Text('Your payout has been sent to your bank account.'),
                    ],
                  ),
                  const Gutter(),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            context.read<PayoutBloc>().add(ResetPayout());
                            context.pop();
                          },
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
          if (state is PayoutInitial || state is PayoutStarted) {
            // var externalAccounts = context
            //     .read<PaymentsBloc>()
            //     .state
            //     .stripeAccount!
            //     .externalAccounts!['data'] as List<dynamic>?;
            bool instantAvailable = context
                        .read<PaymentsBloc>()
                        .state
                        .stripeAccount
                        ?.availablePayoutMethods !=
                    null &&
                context
                    .read<PaymentsBloc>()
                    .state
                    .stripeAccount!
                    .availablePayoutMethods!
                    .contains('instant');
            instantAvailable = true;
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Payout Balance',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Spacer(),
                      Text(
                        convertCentsToCurrency(widget.availableBalance),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                  const GutterSmall(),
                  Row(
                    children: [
                      instantAvailable
                          ? state.payoutMethod == null
                              ? const Flexible(
                                  child: Text(
                                      'Choose between instant or standard payouts.'),
                                )
                              : state.payoutMethod == PayoutMethod.instant
                                  ? const Flexible(
                                      child: Text(
                                          'Instant payouts are subject to a 1% fee.'),
                                    )
                                  : const Flexible(
                                      child: Text(
                                          'Standard payouts take 2 business days.'),
                                    )
                          : Flexible(
                              child: Text(
                                  '${convertCentsToCurrency(widget.availableBalance)} sent to your default Stripe payout method.'),
                            ),
                    ],
                  ),
                  const Gutter(),
                  instantAvailable
                      ? AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: state.payoutMethod == null
                              ? const PayoutMethodButtons()
                              : Column(
                                  children: [
                                    state.payoutMethod == PayoutMethod.instant
                                        ? Row(
                                            children: [
                                              Expanded(
                                                child: FilledButton.icon(
                                                    icon: const Icon(
                                                      Icons.flash_on_rounded,
                                                      size: 16.0,
                                                    ),
                                                    onPressed: () {
                                                      context
                                                          .read<PayoutBloc>()
                                                          .add(RequestPayout(
                                                              payoutMethod:
                                                                  PayoutMethod
                                                                      .instant,
                                                              user: context
                                                                  .read<
                                                                      ProfileBloc>()
                                                                  .state
                                                                  .user!,
                                                              amountInCents: widget
                                                                  .availableBalance));
                                                    },
                                                    label: Text(
                                                        'Instant Payout ${convertCentsToCurrency(widget.availableBalance)}')),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Expanded(
                                                child: FilledButton(
                                                    onPressed: () {
                                                      context
                                                          .read<PayoutBloc>()
                                                          .add(RequestPayout(
                                                              payoutMethod:
                                                                  PayoutMethod
                                                                      .standard,
                                                              user: context
                                                                  .read<
                                                                      ProfileBloc>()
                                                                  .state
                                                                  .user!,
                                                              amountInCents: widget
                                                                  .availableBalance));
                                                    },
                                                    child: Text(
                                                        'Standard Payout ${convertCentsToCurrency(widget.availableBalance)}')),
                                              ),
                                            ],
                                          ),
                                    TextButton(
                                        onPressed: () {
                                          context
                                              .read<PayoutBloc>()
                                              .add(ResetPayout());
                                        },
                                        child:
                                            const Text('Change Payout Method')),
                                  ],
                                ))
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: FilledButton(
                                    onPressed: () {
                                      context.read<PayoutBloc>().add(
                                          RequestPayout(
                                              payoutMethod:
                                                  PayoutMethod.standard,
                                              user: context
                                                  .read<ProfileBloc>()
                                                  .state
                                                  .user!,
                                              amountInCents:
                                                  widget.availableBalance));
                                    },
                                    child: Text(
                                        'Payout ${convertCentsToCurrency(widget.availableBalance)}'),
                                  ),
                                ),
                              ],
                            ),
                            const GutterSmall(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_rounded,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 14.0,
                                ),
                                const GutterSmall(),
                                Text('Processing takes 2 business days.',
                                    textAlign: TextAlign.center,
                                    style:
                                        Theme.of(context).textTheme.bodySmall),
                              ],
                            )
                          ],
                        )
                ],
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong...'));
          }
        },
      ),
    );
  }
}

class PayoutMethodButtons extends StatelessWidget {
  const PayoutMethodButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                  icon: const Icon(
                    Icons.flash_on_rounded,
                    size: 16.0,
                  ),
                  label: const Text('Instant'),
                  onPressed: () {
                    context.read<PayoutBloc>().add(
                        const StartPayout(payoutMethod: PayoutMethod.instant));
                  }),
              const GutterTiny(),
              Text(
                '1% fee',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Gutter(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                child: const Text('Standard'),
                onPressed: () {
                  context.read<PayoutBloc>().add(
                      const StartPayout(payoutMethod: PayoutMethod.standard));
                },
              ),
              const GutterTiny(),
              Text(
                '2 biz days',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
