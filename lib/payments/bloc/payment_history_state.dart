part of 'payment_history_bloc.dart';

abstract class PaymentHistoryState extends Equatable {
  const PaymentHistoryState();
  
  @override
  List<Object> get props => [];
}

class PaymentHistoryInitial extends PaymentHistoryState {}
