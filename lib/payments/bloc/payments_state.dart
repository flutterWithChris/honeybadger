part of 'payments_bloc.dart';

enum StripeAccountStatus { notCreated, incomplete, complete }

abstract class PaymentsState extends Equatable {
  final StripeAccount? stripeAccount;
  final String? loginLink;
  final StripeAccountStatus? stripeAccountStatus;
  const PaymentsState(
      {this.stripeAccount, this.stripeAccountStatus, this.loginLink});

  @override
  List<Object?> get props => [stripeAccount, stripeAccountStatus, loginLink];
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  @override
  final StripeAccount? stripeAccount;
  @override
  final String? loginLink;
  @override
  final StripeAccountStatus stripeAccountStatus;
  const PaymentsLoaded(
      {this.stripeAccount, this.loginLink, required this.stripeAccountStatus});
  @override
  // TODO: implement props
  List<Object?> get props => [stripeAccount, loginLink];
}

class PaymentsError extends PaymentsState {
  final String message;
  const PaymentsError({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class PaymentSent extends PaymentsState {}
