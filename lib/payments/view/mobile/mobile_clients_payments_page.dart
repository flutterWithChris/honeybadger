import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/extensions.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/payments/bloc/payments_bloc.dart';
import 'package:honeybadger/payouts/bloc/payout_bloc.dart';
import 'package:honeybadger/payouts/model/payout.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobileClientPaymentsPage extends StatefulWidget {
  const MobileClientPaymentsPage({super.key});

  @override
  State<MobileClientPaymentsPage> createState() =>
      _MobileClientPaymentsPageState();

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

class _MobileClientPaymentsPageState extends State<MobileClientPaymentsPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
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
              const MobileSliverAppBar(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payments',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const Gutter(),
                    ],
                  ),
                ),
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
                          ElevatedButton(
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
                  if (paymentsState.charges == null ||
                      paymentsState.charges!.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(MdiIcons.creditCardOutline,
                                size: 72.0,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.grey[500]
                                    : Colors.grey[600]),
                            const Gutter(),
                            Text('No payments yet!',
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
                  if (paymentsState.charges != null &&
                      paymentsState.charges!.isNotEmpty) {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 0.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            // DateTime availableDate =
                            //     Jiffy.parseFromMillisecondsSinceEpoch(
                            //             paymentsState
                            //                     .charges![index]
                            //                     .availableOn! *
                            //                 1000)
                            //         .dateTime;

                            // String transactionType =
                            //     paymentsState.charges![index].type!;
                            // if (transactionType == 'transfer') {
                            //   transactionType = 'Payment';
                            // }
                            return Column(
                              children: [
                                index == 0 ? const Divider() : const SizedBox(),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ListTile(
                                      onTap: () {
                                        // context.go(
                                        //     '/payments/details/${paymentsState.charges![index].id}',
                                        //     extra: paymentsState
                                        //         .charges![index]);
                                        // TODO: Reenable this
                                        // showBottomSheet(
                                        //     enableDrag: true,
                                        //     context: context,
                                        //     builder: (context) =>
                                        //         DraggableScrollableSheet(
                                        //           expand: false,
                                        //           initialChildSize: 0.21,
                                        //           minChildSize: 0.2,
                                        //           builder: (context,
                                        //                   scrollController) =>
                                        //               PaymentDetailsPage(
                                        //                   balanceTransaction:
                                        //                       paymentsState
                                        //                               .charges![
                                        //                           index]),
                                        //         ));
                                      },
                                      leading: paymentsState
                                                  .charges![index].status ==
                                              'succeeded'
                                          ? Icon(
                                              MdiIcons.checkBold,
                                              size: 20.0,
                                              color: Colors.green,
                                            )
                                          : paymentsState
                                                      .charges![index].status ==
                                                  'pending'
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
                                      subtitle: paymentsState
                                                      .charges![index].status ==
                                                  'pending' ||
                                              paymentsState
                                                      .charges![index].status ==
                                                  'failed'
                                          ? Row(
                                              children: [
                                                SizedBox(
                                                  height: 30.0,
                                                  child: FittedBox(
                                                    child: Chip(
                                                      visualDensity:
                                                          VisualDensity.compact,
                                                      side: BorderSide.none,
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 4.0),
                                                      avatar: Icon(paymentsState
                                                                  .charges![
                                                                      index]
                                                                  .status ==
                                                              'pending'
                                                          ? Icons.pending
                                                          : Icons
                                                              .error_rounded),
                                                      labelPadding:
                                                          const EdgeInsets.only(
                                                              right: 12.0),
                                                      label: Text(
                                                        paymentsState
                                                            .charges![index]
                                                            .status
                                                            .toString()
                                                            .capitalize,
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Colors
                                                                    .white),
                                                      ),
                                                      backgroundColor:
                                                          paymentsState
                                                                      .charges![
                                                                          index]
                                                                      .status ==
                                                                  'pending'
                                                              ? Colors.grey
                                                              : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : null,
                                      title: Text(
                                        paymentsState
                                                .charges![index].description ??
                                            'Payment',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      // TODO: Add payment status widge
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            convertCentsToCurrency(paymentsState
                                                .charges![index].amount!),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium
                                                ?.copyWith(
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
                                                    paymentsState
                                                            .charges![index]
                                                            .created! *
                                                        1000)
                                                .fromNow(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                                .brightness ==
                                                            Brightness.light
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
                          },
                          childCount: paymentsState.charges!.length,
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
                  const Row(
                    children: [
                      Text('Choose between instant or standard payouts.'),
                    ],
                  ),
                  const Gutter(),
                  context
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
                              .contains('instant')
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
