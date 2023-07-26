part of 'payments_bloc.dart';

abstract class PaymentsState extends Equatable {
  final StripeAccount? stripeAccount;
  const PaymentsState({this.stripeAccount});

  @override
  List<Object> get props => [];
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  @override
  final StripeAccount? stripeAccount;
  const PaymentsLoaded({this.stripeAccount});
}

class PaymentsError extends PaymentsState {
  final String message;
  const PaymentsError({required this.message});
}

class PaymentSent extends PaymentsState {}
