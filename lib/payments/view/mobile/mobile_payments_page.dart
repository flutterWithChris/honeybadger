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
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MobilePaymentsPage extends StatelessWidget {
  const MobilePaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: SafeArea(
          child: RefreshIndicator(
            // header: const ClassicHeader(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   hapticFeedback: true,
            //   triggerOffset: 70.0,
            //   clamping: false,

            // ),
            // spring:
            //     const SpringDescription(mass: 60, stiffness: 100, damping: 500),
            onRefresh: () async {
              context.read<PaymentsBloc>().add(
                  LoadPayments(user: context.read<ProfileBloc>().state.user!));
            },
            child: CustomScrollView(
              slivers: [
                const MobileSliverAppBar(),
                BlocBuilder<PaymentsBloc, PaymentsState>(
                  builder: (context, state) {
                    if (state is PaymentsLoaded && state.loginLink != null) {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              FractionallySizedBox(
                                widthFactor: 0.8,
                                child: FilledButton.icon(
                                    style:
                                        state.stripeAccount?.payoutsEnabled ==
                                                false
                                            ? FilledButton.styleFrom(
                                                backgroundColor: Colors.red,
                                                foregroundColor: Colors.white)
                                            : null,
                                    onPressed: () {
                                      launchUrlString(state.loginLink!,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    icon: Icon(
                                        state.stripeAccount?.payoutsEnabled ==
                                                false
                                            ? Icons.error_rounded
                                            : Icons.dashboard,
                                        size: 20.0),
                                    label: const Text('View Dashboard')),
                              ),
                              // const Gutter(),
                              // FractionallySizedBox(
                              //   widthFactor: 0.8,
                              //   child: FilledButton.icon(
                              //       style:
                              //           state.stripeAccount?.payoutsEnabled ==
                              //                   false
                              //               ? FilledButton.styleFrom(
                              //                   backgroundColor: Colors.red,
                              //                   foregroundColor: Colors.white)
                              //               : null,
                              //       onPressed: () {
                              //         context.read<PaymentsBloc>().add(
                              //             SendPayment(
                              //                 client: User(
                              //                   email: 'billy@email.com',
                              //                   stripeAccountId:
                              //                       'acct_1NYeAV4JF4nBzb2w',
                              //                 ),
                              //                 freelancer: context
                              //                     .read<ProfileBloc>()
                              //                     .state
                              //                     .user!,
                              //                 context: context));
                              //       },
                              //       icon: Icon(
                              //           state.stripeAccount?.payoutsEnabled ==
                              //                   false
                              //               ? Icons.error_rounded
                              //               : Icons.dashboard,
                              //           size: 20.0),
                              //       label: const Text('Test Payment')),
                              // ),
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
                                icon:
                                    const Icon(Icons.error_rounded, size: 20.0),
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
                              color: Theme.of(context).brightness ==
                                      Brightness.light
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
                    if (paymentsState.balanceTransactions == null ||
                        paymentsState.balanceTransactions!.isEmpty) {
                      return SliverFillRemaining(
                        child: Center(
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
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              String transactionType = paymentsState
                                  .balanceTransactions![index].type!;
                              if (transactionType == 'transfer') {
                                transactionType = 'Payment';
                              }
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: ListTile(
                                      onTap: () => context.go(
                                          '/payments/details/${paymentsState.balanceTransactions![index].id}',
                                          extra: paymentsState
                                              .balanceTransactions![index]),
                                      leading: paymentsState
                                                  .balanceTransactions![index]
                                                  .status ==
                                              'available'
                                          ? Icon(
                                              MdiIcons.checkBold,
                                              size: 16.0,
                                              color: Colors.green,
                                            )
                                          : paymentsState
                                                      .balanceTransactions![
                                                          index]
                                                      .status ==
                                                  'pending'
                                              ? const Icon(
                                                  Icons.pending,
                                                  size: 16.0,
                                                  color: Colors.grey,
                                                )
                                              : const Icon(
                                                  Icons.close,
                                                  size: 16.0,
                                                  color: Colors.red,
                                                ),
                                      title: Row(
                                        children: [
                                          Text(
                                              transactionType
                                                  .replaceAll('_', ' ')
                                                  .toTitleCase(),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold)),
                                          paymentsState
                                                      .balanceTransactions![
                                                          index]
                                                      .availableOn !=
                                                  null
                                              ? Flexible(
                                                  child: Text(
                                                    ' - Available on ${Jiffy.parseFromMillisecondsSinceEpoch(paymentsState.balanceTransactions![index].availableOn! * 1000).MMMd}',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                            color: Theme.of(context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Colors
                                                                    .grey[500]
                                                                : Colors
                                                                    .grey[600]),
                                                  ),
                                                )
                                              : const GutterTiny(),
                                        ],
                                      ),
                                      subtitle: paymentsState
                                                  .balanceTransactions?[index]
                                                  .description !=
                                              null
                                          ? Text(
                                              paymentsState
                                                  .balanceTransactions![index]
                                                  .description!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium)
                                          : const SizedBox(),
                                      // TODO: Add payment status widge
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            convertCentsToCurrency(paymentsState
                                                .balanceTransactions![index]
                                                .amount!),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
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
                                                            .balanceTransactions![
                                                                index]
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
                              );
                            },
                            childCount:
                                paymentsState.balanceTransactions!.length,
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
                })
              ],
            ),
          ),
        ));
  }
}
