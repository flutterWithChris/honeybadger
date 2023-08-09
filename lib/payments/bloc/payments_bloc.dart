import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/payments/model/balance.dart';
import 'package:honeybadger/payments/model/balance_transaction.dart';
import 'package:honeybadger/payments/model/stripe_account.dart';
import 'package:honeybadger/payments/repository/payments_repository.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';
import 'package:honeybadger/proposals/model/proposal.dart';

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
    _profileSubscription = _profileBloc.stream.listen((profileState) {
      print('Profile State: $profileState');
      if (profileState is ProfileLoaded && state is PaymentsInitial) {
        add(LoadPayments(user: profileState.user));
      }
    });
    print('Payments State: $state');
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
        print('***App Resumed***');
        break;
      case AppLifecycleState.inactive:
        print('***App Inactive***');
        break;
      case AppLifecycleState.paused:
        print('***App Paused***');
        break;
      case AppLifecycleState.detached:
        print('***App Detached***');
        break;
      default:
        print('***App Default***');
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

    await _paymentsRepository.initPaymentSheet(
      event.context,
      email: event.client.email!,
      amount: event.amount,
      freelancerStripeAccountId: event.freelancerStripeAccountId,
      description: 'Payment for ${event.proposal.projectName}',
      metadata: {
        'proposalId': event.proposal.id,
        'clientId': event.client.id,
        'clientName': '${event.client.firstName} ${event.client.lastName}',
        'freelancerId': event.freelancerId,
      },
    );
    emit(PaymentSent());
  }

  void _onLoadPayments(LoadPayments event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    StripeAccount? stripeAccount;
    Balance? balance;
    List<BalanceTransaction>? balanceTransactions;
    String? loginLink;
    if (event.user.stripeAccountId != null &&
        event.user.stripeAccountId!.isNotEmpty) {
      stripeAccount = await _paymentsRepository
          .fetchStripeAccount(event.user.stripeAccountId!);
      // bool stripeSetupComplete =
      //     (stripeAccount?.requirements?['currently_due'] as List?)?.isEmpty ??
      //         true;
      bool stripeSetupComplete = stripeAccount?.detailsSubmitted ?? true;
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
      print('Available payout methods: ${stripeAccount?.externalAccounts}}');
      emit(PaymentsLoaded(
          stripeAccount: stripeAccount,
          loginLink: loginLink,
          stripeAccountStatus: stripeSetupComplete
              ? StripeAccountStatus.complete
              : StripeAccountStatus.incomplete,
          balance: balance,
          balanceTransactions: balanceTransactions));
      return;
    } else {
      emit(const PaymentsLoaded(
          stripeAccountStatus: StripeAccountStatus.notCreated));
      print('There is no stripe account');
      return;
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
      print('There is no stripe account');
      return;
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    WidgetsBinding.instance.removeObserver(this);
    return super.close();
  }
}
