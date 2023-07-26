part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  const PaymentsEvent();

  @override
  List<Object> get props => [];
}

class LoadPayments extends PaymentsEvent {}

class SetupPaymentAccount extends PaymentsEvent {
  User user;
  BuildContext context;
  SetupPaymentAccount({required this.user, required this.context});
}

class SendPayment extends PaymentsEvent {
  User client;
  User freelancer;
  BuildContext context;
  SendPayment(
      {required this.client, required this.freelancer, required this.context});
}
