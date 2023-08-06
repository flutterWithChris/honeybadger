part of 'payout_bloc.dart';

sealed class PayoutEvent extends Equatable {
  const PayoutEvent();

  @override
  List<Object> get props => [];
}

class RequestPayout extends PayoutEvent {
  final User user;
  final int amountInCents;
  final PayoutMethod payoutMethod;

  const RequestPayout({
    required this.user,
    required this.amountInCents,
    required this.payoutMethod,
  });
}

class StartPayout extends PayoutEvent {
  final PayoutMethod payoutMethod;

  const StartPayout({
    required this.payoutMethod,
  });
}

class ResetPayout extends PayoutEvent {}
