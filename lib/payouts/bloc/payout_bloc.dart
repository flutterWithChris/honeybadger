import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:outsourcedx/payments/repository/payments_repository.dart';
import 'package:outsourcedx/payouts/model/payout.dart';
import 'package:outsourcedx/profile/model/user.dart';

part 'payout_event.dart';
part 'payout_state.dart';

class PayoutBloc extends Bloc<PayoutEvent, PayoutState> {
  final PaymentsRepository _paymentsRepository;
  final PayoutMethod _payoutMethod = PayoutMethod.standard;
  PayoutBloc({required PaymentsRepository paymentsRepository})
      : _paymentsRepository = paymentsRepository,
        super(PayoutInitial()) {
    on<RequestPayout>(_onRequestPayout);
    on<StartPayout>(_onStartPayout);
    on<ResetPayout>((event, emit) => emit(PayoutInitial()));
  }
  void _onRequestPayout(RequestPayout event, Emitter<PayoutState> emit) async {
    emit(PayoutLoading());
    try {
      final payout = await _paymentsRepository.requestPayout(
        stripeAccountId: event.user.stripeAccountId!,
        amount: event.amountInCents,
        payoutMethod: event.payoutMethod,
      );
      // final payout = Payout(
      //   id: '1',
      //   amount: 100,
      //   currency: 'USD',
      //   status: 'in_transit',
      // );
      await Future.delayed(const Duration(seconds: 2));

      emit(PayoutSuccess(payout: payout));
    } catch (e) {
      emit(PayoutFailure(
          message: 'Failed to request payout',
          payoutMethod: PayoutMethod.standard,
          amountInCents: 100,
          user: event.user));
    }
  }

  void _onStartPayout(StartPayout event, Emitter<PayoutState> emit) async {
    try {
      emit(PayoutStarted(payoutMethod: event.payoutMethod));
    } catch (e) {
      emit(PayoutFailure(message: e.toString()));
    }
  }
}
