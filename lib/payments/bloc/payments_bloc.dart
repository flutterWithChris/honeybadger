import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/payments/model/balance.dart';
import 'package:outsourcedx/payments/model/balance_transaction.dart';
import 'package:outsourcedx/payments/model/charge.dart';
import 'package:outsourcedx/payments/model/stripe_account.dart';
import 'package:outsourcedx/payments/repository/payments_repository.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/proposals/model/proposal.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState>
    with WidgetsBindingObserver {
  final ProfileBloc _profileBloc;
  StreamSubscription<ProfileState>? _profileSubscription;
  final PaymentsRepository _paymentsRepository;
  PaymentsBloc(
      {required PaymentsRepository paymentsRepository,
      required ProfileBloc profileBloc})
      : _paymentsRepository = paymentsRepository,
        _profileBloc = profileBloc,
        super(PaymentsInitial()) {
    WidgetsBinding.instance.addObserver(this);
    on<SetupPaymentAccount>(_onSetupPaymentAccount);
    on<FinishSetupPaymentAccount>(_onFinishSetupPaymentAccount);
    on<LoadPayments>(_onLoadPayments);
    on<SendPayment>(_onSendPayment);
    on<LoadBalanceAndTransactions>(_onLoadBalanceAndTransactions);
    on<LoadCharges>(_onLoadCharges);
    _profileSubscription = _profileBloc.stream.listen((profileState) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool paymentSetupComplete =
          prefs.getBool('paymentSetupComplete') ?? false;
      if (profileState is ProfileLoaded &&
          state is PaymentsInitial &&
          paymentSetupComplete) {
        add(LoadPayments(user: profileState.user));
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(appState);
    switch (appState) {
      case AppLifecycleState.resumed:
        state is PaymentsLoading
            ? add(LoadPayments(user: _profileBloc.state.user!))
            : null;
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      default:
    }
  }

  void _onSetupPaymentAccount(
      SetupPaymentAccount event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    String stripeAccountId = await _paymentsRepository.setupPaymentAccount(
      event.context,
      email: event.user.email!,
      userId: event.user.id!,
    );
    User updatedUser = event.user.copyWith(stripeAccountId: stripeAccountId);
    // TODO: Update user with stripe account id
    _profileBloc.add(UpdateProfile(user: updatedUser));
  }

  void _onFinishSetupPaymentAccount(
      FinishSetupPaymentAccount event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    await _paymentsRepository
        .finishStripeConnectOnboarding(event.user.stripeAccountId!);
  }

  void _onSendPayment(SendPayment event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    try {
      String? customerId = await _paymentsRepository.initPaymentSheet(
        event.context,
        email: event.client.email!,
        amount: (event.amount * 1.05).round(),
        applicationFeeAmount: (event.amount * 0.10).round(),
        freelancerStripeAccountId: event.freelancerStripeAccountId,
        description: 'Payment for ${event.proposal.projectName}',
        metadata: {
          'proposalId': event.proposal.id,
          'clientId': event.client.id,
          'clientName': '${event.client.firstName} ${event.client.lastName}',
          'freelancerId': event.freelancerId,
        },
      );
      if (_profileBloc.state.user!.stripeAccountId == null ||
          _profileBloc.state.user!.stripeAccountId!.isEmpty) {
        _profileBloc.add(UpdateProfile(
            user: _profileBloc.state.user!
                .copyWith(stripeAccountId: customerId)));
      }
      emit(PaymentSent());
    } catch (e) {
      emit(PaymentsError(message: e.toString()));
    }
  }

  void _onLoadPayments(LoadPayments event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    StripeAccount? stripeAccount;
    Balance? balance;
    List<BalanceTransaction>? balanceTransactions;
    String? loginLink;
    try {
      if (_profileBloc.state.user!.userType! == UserType.freelancer) {
        if (event.user.stripeAccountId != null &&
            event.user.stripeAccountId!.isNotEmpty) {
          stripeAccount = await _paymentsRepository
              .fetchStripeAccount(event.user.stripeAccountId!);
          // bool stripeSetupComplete =
          //     (stripeAccount?.requirements?['currently_due'] as List?)?.isEmpty ??
          //         true;
          var currentDue = stripeAccount?.requirements;
          bool? stripeSetupComplete =
              (stripeAccount?.requirements?['currently_due'] as List?)?.isEmpty;
          if (stripeSetupComplete == true) {
            var futures = [
              _paymentsRepository.getLoginLink(event.user.stripeAccountId!),
              _paymentsRepository.getBalance(event.user.stripeAccountId!),
              _paymentsRepository.getBalanceTransactions(
                event.user.stripeAccountId!,
              ),
            ];
            var results = await Future.wait(futures);
            loginLink = results[0] as String;
            balance = results[1] as Balance;
            balanceTransactions = results[2] as List<BalanceTransaction>;
          }
          emit(PaymentsLoaded(
              stripeAccount: stripeAccount,
              loginLink: loginLink,
              stripeAccountStatus: stripeSetupComplete == true
                  ? StripeAccountStatus.complete
                  : StripeAccountStatus.incomplete,
              balance: balance,
              balanceTransactions: balanceTransactions));
          return;
        } else {
          emit(const PaymentsLoaded(
              stripeAccountStatus: StripeAccountStatus.notCreated));
          return;
        }
      } else {
        // TODO: Load Client Charges
        if (event.user.stripeAccountId != null) {
          List<Charge> charges = await _paymentsRepository.getCharges(
              stripeAccountId: event.user.stripeAccountId!);
          emit(PaymentsLoaded(
              stripeAccountStatus: StripeAccountStatus.complete,
              charges: charges));
        } else {
          emit(const PaymentsLoaded(
              stripeAccountStatus: StripeAccountStatus.notCreated));
          return;
        }

        return;
      }
    } catch (e) {
      emit(PaymentsError(message: e.toString()));
    }
  }

  void _onLoadBalanceAndTransactions(
      LoadBalanceAndTransactions event, Emitter<PaymentsState> emit) async {
    var previousState = state;
    emit(PaymentsLoading());
    Balance? balance;
    List<BalanceTransaction>? balanceTransactions;
    if (event.user.stripeAccountId != null &&
        event.user.stripeAccountId!.isNotEmpty) {
      var futures = [
        _paymentsRepository.getBalance(event.user.stripeAccountId!),
        _paymentsRepository.getBalanceTransactions(
          event.user.stripeAccountId!,
        ),
      ];
      var results = await Future.wait(futures);
      balance = results[0] as Balance;
      balanceTransactions = results[1] as List<BalanceTransaction>;
      emit(PaymentsLoaded(
          balance: balance,
          balanceTransactions: balanceTransactions,
          stripeAccountStatus: previousState.stripeAccountStatus,
          stripeAccount: previousState.stripeAccount,
          loginLink: previousState.loginLink));
      return;
    } else {
      emit(const PaymentsLoaded(
          stripeAccountStatus: StripeAccountStatus.notCreated));
      return;
    }
  }

  void _onLoadCharges(LoadCharges event, Emitter<PaymentsState> emit) async {
    try {
      emit(PaymentsLoading());
      List<Charge> charges = await _paymentsRepository.getCharges(
          stripeAccountId: event.user.stripeAccountId!);
      emit(PaymentsLoaded(
          stripeAccountStatus: StripeAccountStatus.notCreated,
          charges: charges));
      return;
    } catch (e) {
      emit(PaymentsError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
