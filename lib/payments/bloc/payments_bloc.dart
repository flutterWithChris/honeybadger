import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/payments/repository/payments_repository.dart';
import 'package:honeybadger/profile/model/user.dart';

part 'payments_event.dart';
part 'payments_state.dart';

class PaymentsBloc extends Bloc<PaymentsEvent, PaymentsState> {
  final PaymentsRepository _paymentsRepository;
  PaymentsBloc({required PaymentsRepository paymentsRepository})
      : _paymentsRepository = paymentsRepository,
        super(PaymentsInitial()) {
    on<SetupPaymentAccount>(_onSetupPaymentAccount);
    on<LoadPayments>(_onLoadPayments);
    on<SendPayment>(_onSendPayment);
  }
  void _onSetupPaymentAccount(
      SetupPaymentAccount event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    await _paymentsRepository.setupPaymentAccount(
      event.context,
      email: event.user.email!,
    );

    emit(PaymentsLoaded());
  }

  void _onSendPayment(SendPayment event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    await _paymentsRepository.initPaymentSheet(
      event.context,
      email: event.client.email!,
      amount: 100.0,
      freelancerStripeId: event.freelancer.stripeId!,
    );
    emit(PaymentSent());
  }

  void _onLoadPayments(LoadPayments event, Emitter<PaymentsState> emit) async {
    emit(PaymentsLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(PaymentsLoaded());
  }
}
