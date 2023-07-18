import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<PaymentHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
