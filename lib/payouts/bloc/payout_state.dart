part of 'payout_bloc.dart';

sealed class PayoutState extends Equatable {
  final User? user;
  final PayoutMethod? payoutMethod;
  final int? amountInCents;
  const PayoutState({this.user, this.payoutMethod, this.amountInCents});

  @override
  List<Object?> get props => [user, payoutMethod, amountInCents];
}

final class PayoutInitial extends PayoutState {}

final class PayoutLoading extends PayoutState {}

final class PayoutStarted extends PayoutState {
  @override
  final PayoutMethod payoutMethod;
  @override
  final User? user;
  @override
  final int? amountInCents;

  const PayoutStarted(
      {required this.payoutMethod, this.user, this.amountInCents});

  @override
  List<Object?> get props => [payoutMethod, user, amountInCents];
}

final class PayoutSuccess extends PayoutState {
  final Payout payout;

  const PayoutSuccess({required this.payout});

  @override
  List<Object> get props => [payout];
}

final class PayoutFailure extends PayoutState {
  final String message;
  @override
  final User? user;
  @override
  final PayoutMethod? payoutMethod;
  @override
  final int? amountInCents;

  const PayoutFailure(
      {required this.message,
      this.user,
      this.payoutMethod,
      this.amountInCents});

  @override
  List<Object?> get props => [message, user, payoutMethod, amountInCents];
}
