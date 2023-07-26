part of 'payment_history_bloc.dart';

abstract class PaymentHistoryState extends Equatable {
  final List<Payment>? payments;
  const PaymentHistoryState({this.payments});

  @override
  List<Object?> get props => [payments];
}

class PaymentHistoryInitial extends PaymentHistoryState {}

class PaymentHistoryLoading extends PaymentHistoryState {}

class PaymentHistoryLoaded extends PaymentHistoryState {
  @override
  final List<Payment> payments;
  const PaymentHistoryLoaded({required this.payments})
      : super(payments: payments);

  @override
  List<Object?> get props => [payments];
}

class PaymentHistoryError extends PaymentHistoryState {
  final String message;
  const PaymentHistoryError({required this.message}) : super();

  @override
  List<Object?> get props => [message];
}

class PaymentHistoryEmpty extends PaymentHistoryState {}
