part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class LoadPayments extends PaymentsEvent {}

class SetupPaymentAccount extends PaymentsEvent {
  User user;
  SetupPaymentAccount({required this.user});
}
