import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/payments/view/desktop/desktop_payments_page.dart';
import 'package:honeybadger/payments/view/mobile/mobile_clients_payments_page.dart';
import 'package:honeybadger/payments/view/mobile/mobile_payments_page.dart';
import 'package:honeybadger/payments/view/tablet/tablet_payments_page.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';

class PaymentsPage extends StatelessWidget {
  const PaymentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > desktopWidthConstraint) {
          return const DesktopPaymentsPage();
        } else if (constraints.maxWidth > tabletWidthConstraint) {
          return const TabletPaymentsPage();
        } else {
          if (context.read<ProfileBloc>().state.user!.userType ==
              UserType.client) {
            return const MobileClientPaymentsPage();
          }
          return const MobilePaymentsPage();
        }
      },
    );
  }
}
