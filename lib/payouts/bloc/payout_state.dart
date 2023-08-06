part of 'payout_bloc.dart';

sealed class PayoutState extends Equatable {
  final PayoutMethod? payoutMethod;
  const PayoutState({this.payoutMethod});

  @override
  List<Object> get props => [];
}

final class PayoutInitial extends PayoutState {}

final class PayoutLoading extends PayoutState {}

final class PayoutStarted extends PayoutState {
  @override
  final PayoutMethod payoutMethod;

  const PayoutStarted({required this.payoutMethod});

  @override
  List<Object> get props => [payoutMethod];
}

final class PayoutSuccess extends PayoutState {
  final Payout payout;

  const PayoutSuccess({required this.payout});

  @override
  List<Object> get props => [payout];
}

final class PayoutFailure extends PayoutState {
  final String message;

  const PayoutFailure({required this.message});

  @override
  List<Object> get props => [message];
}
