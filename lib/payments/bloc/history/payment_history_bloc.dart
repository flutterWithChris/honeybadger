import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:OutsourcedX/globals.dart';
import 'package:OutsourcedX/payments/model/payment.dart';

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
            id: generateUniqueId(),
            status: PaymentStatus.pending,
            type: PaymentType.fixed,
            payerId: generateUniqueId(),
            payerName: 'Jeff Bezos',
            payeeId: generateUniqueId(),
            payeeName: 'Jane Doe',
            paymentDate:
                DateTime.now().subtract(const Duration(minutes: 6)).toString(),
            amount: 2500.0,
            hours: null,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: generateUniqueId(),
            milestoneTitle: 'Backend Complete',
            projectId: generateUniqueId(),
            projectTitle: 'Mobile app development'),
        Payment(
            id: generateUniqueId(),
            status: PaymentStatus.paid,
            type: PaymentType.fixed,
            payerId: generateUniqueId(),
            payerName: 'Alice Taylor',
            payeeId: generateUniqueId(),
            payeeName: 'Jane Doe',
            paymentDate:
                DateTime.now().subtract(const Duration(days: 14)).toString(),
            amount: 2500.0,
            hours: null,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: generateUniqueId(),
            milestoneTitle: 'UI Complete',
            projectId: generateUniqueId(),
            projectTitle: 'Mobile app development'),
        Payment(
            id: generateUniqueId(),
            status: PaymentStatus.failed,
            type: PaymentType.hourly,
            payerId: generateUniqueId(),
            payerName: 'Fred Smith',
            payeeId: generateUniqueId(),
            payeeName: 'Jane Doe',
            paymentDate: '2023-06-15',
            amount: 700.0,
            hours: 10.0,
            currency: 'USD',
            description: 'Payment for work done on project.',
            milestoneId: null,
            milestoneTitle: null,
            projectId: generateUniqueId(),
            projectTitle: 'Veterinarian App'),
      ];
      payments.isEmpty
          ? emit(PaymentHistoryEmpty())
          : emit(PaymentHistoryLoaded(payments: payments));
    });
  }
}
