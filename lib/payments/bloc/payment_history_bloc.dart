import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/payments/model/payment.dart';

part 'payment_history_event.dart';
part 'payment_history_state.dart';

class PaymentHistoryBloc
    extends Bloc<PaymentHistoryEvent, PaymentHistoryState> {
  PaymentHistoryBloc() : super(PaymentHistoryInitial()) {
    on<FetchPaymentHistory>((event, emit) async {
      emit(PaymentHistoryLoading());
      await Future.delayed(const Duration(seconds: 1));
      List<Payment> payments = [];
      payments = [
        Payment(
            id: '1',
            status: PaymentStatus.paid,
            type: PaymentType.fixed,
            payerId: '1',
            payerName: 'John Doe',
            payeeId: '2',
            payeeName: 'Jane Doe',
            paymentDate: '2023-07-15',
            amount: 2500.0,
            hours: null,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: null,
            milestoneTitle: 'Backend Complete',
            projectId: '1',
            projectTitle: 'Mobile app development'),
        Payment(
            id: '2',
            status: PaymentStatus.pending,
            type: PaymentType.fixed,
            payerId: '1',
            payerName: 'John Doe',
            payeeId: '2',
            payeeName: 'Jane Doe',
            paymentDate: '2023-07-01',
            amount: 2500.0,
            hours: 10.0,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: null,
            milestoneTitle: 'UI Complete',
            projectId: '154',
            projectTitle: 'Mobile app development'),
        Payment(
            id: '3',
            status: PaymentStatus.failed,
            type: PaymentType.hourly,
            payerId: '1',
            payerName: 'John Doe',
            payeeId: '2',
            payeeName: 'Jane Doe',
            paymentDate: '2023-06-15',
            amount: 700.0,
            hours: 10.0,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: null,
            milestoneTitle: null,
            projectId: '154',
            projectTitle: 'Veterinarian App'),
      ];
      payments.isEmpty
          ? emit(PaymentHistoryEmpty())
          : emit(PaymentHistoryLoaded(payments: payments));
    });
  }
}
