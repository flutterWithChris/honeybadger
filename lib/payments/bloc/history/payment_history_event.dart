part of 'payment_history_bloc.dart';

abstract class PaymentHistoryEvent extends Equatable {
  const PaymentHistoryEvent();

  @override
  List<Object> get props => [];
}

class FetchPaymentHistory extends PaymentHistoryEvent {
  final String userId;
  const FetchPaymentHistory({required this.userId});

  @override
  List<Object> get props => [userId];
}
