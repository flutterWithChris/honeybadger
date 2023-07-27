import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/payments/model/stripe_account.dart';
import 'package:honeybadger/payments/repository/payments_repository.dart';
import 'package:honeybadger/profile/bloc/profile_bloc.dart';
import 'package:honeybadger/profile/model/user.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final ProfileBloc _profileBloc;
  final PaymentsRepository _paymentsRepository;
  PaymentsBloc(
      {required PaymentsRepository paymentsRepository,
      required ProfileBloc profileBloc})
      : _paymentsRepository = paymentsRepository,
        _profileBloc = profileBloc,
        super(PaymentsInitial()) {
    on<SetupPaymentAccount>(_onSetupPaymentAccount);
    on<FinishSetupPaymentAccount>(_onFinishSetupPaymentAccount);
    on<LoadPayments>(_onLoadPayments);
    on<SendPayment>(_onSendPayment);
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
      amount: 100.0,
      freelancerStripeId: event.freelancer.stripeAccountId!,
    );
    emit(PaymentSent());
  }

  void _onLoadPayments(LoadPayments event, Emitter<PaymentsState> emit) async {
    StripeAccount? stripeAccount = await _paymentsRepository
        .fetchStripeAccount(event.user.stripeAccountId!);
    String? loginLink;
    bool stripeSetupComplete =
        (stripeAccount?.requirements?['currently_due'] as List).isEmpty;
    if (stripeSetupComplete == true) {
      loginLink = await _paymentsRepository.getLoginLink(
        event.user.stripeAccountId!,
      );
      emit(PaymentsLoaded(
          stripeAccount: stripeAccount,
          loginLink: loginLink,
          stripeAccountStatus: StripeAccountStatus.complete));
      return;
    } else if (stripeAccount != null) {
      emit(PaymentsLoaded(
          stripeAccount: stripeAccount,
          loginLink: loginLink,
          stripeAccountStatus: StripeAccountStatus.incomplete));
      print('There are currently due requirements');
      return;
    } else {
      emit(PaymentsLoaded(
          stripeAccount: stripeAccount,
          loginLink: loginLink,
          stripeAccountStatus: StripeAccountStatus.notCreated));
      print('There is no stripe account');
      return;
    }
  }
}
