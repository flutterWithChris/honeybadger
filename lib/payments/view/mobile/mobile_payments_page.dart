import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gutter/flutter_gutter.dart';
import 'package:go_router/go_router.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/core/presentation/system/main_navigation_bar.dart';
import 'package:honeybadger/core/presentation/system/mobile_sliver_app_bar.dart';
import 'package:honeybadger/payments/bloc/payment_history_bloc.dart';
import 'package:honeybadger/payments/details/mobile/mobile_payment_details.dart';
import 'package:honeybadger/payments/model/payment.dart';
import 'package:jiffy/jiffy.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MobilePaymentsPage extends StatelessWidget {
  const MobilePaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: const MainBottomNavBar(),
        body: CustomScrollView(
          slivers: [
            const MobileSliverAppBar(),
            BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
              builder: (context, state) {
                if (state is PaymentHistoryError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(state.message),
                    ),
                  );
                }
                if (state is PaymentHistoryLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is PaymentHistoryEmpty) {
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
                if (state is PaymentHistoryLoaded) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Card(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: ListTile(
                                  onTap: () => context.go(
                                      '/payments/details/${state.payments[index].id}',
                                      extra: state.payments[index]),
                                  leading: state.payments[index].status ==
                                          PaymentStatus.paid
                                      ? Icon(
                                          MdiIcons.checkBold,
                                          size: 16.0,
                                          color: Colors.green,
                                        )
                                      : state.payments[index].status ==
                                              PaymentStatus.pending
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
                                      state.payments[index].type ==
                                                  PaymentType.fixed &&
                                              state.payments[index]
                                                      .milestoneTitle !=
                                                  null
                                          ? Text(
                                              state.payments[index]
                                                  .milestoneTitle!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium)
                                          : Text(
                                              state.payments[index]
                                                  .projectTitle!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium),
                                      const GutterTiny(),
                                      Text(
                                          state.payments[index].type ==
                                                  PaymentType.fixed
                                              ? '- Fixed'
                                              : '- Hourly',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                  fontStyle: FontStyle.italic)),
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: FittedBox(
                                          child: PayerChip(
                                              payment: state.payments[index]),
                                        ),
                                      ),
                                    ],
                                  ), // TODO: Add payment status widge
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        convertDoubleToString(
                                            state.payments[index].amount!),
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
                                        Jiffy.parse(state
                                                .payments[index].paymentDate!)
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
                        childCount: state.payments.length,
                      ),
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('Something went wrong...'),
                    ),
                  );
                }
              },
            )
          ],
        ));
  }
}
