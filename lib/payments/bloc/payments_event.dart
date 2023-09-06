part of 'payments_bloc.dart';

abstract class PaymentsEvent extends Equatable {
  final User? user;
  const PaymentsEvent({this.user});

  @override
  List<Object?> get props => [user];
}

class LoadPayments extends PaymentsEvent {
  @override
  final User user;
  const LoadPayments({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class LoadBalanceAndTransactions extends PaymentsEvent {
  @override
  final User user;
  const LoadBalanceAndTransactions({required this.user});
  @override
  List<Object?> get props => [user];
}

class LoadCharges extends PaymentsEvent {
  @override
  final User user;
  const LoadCharges({required this.user});
  @override
  List<Object?> get props => [user];
}

class SetupPaymentAccount extends PaymentsEvent {
  @override
  User user;
  BuildContext context;
  SetupPaymentAccount({required this.user, required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class FinishSetupPaymentAccount extends PaymentsEvent {
  @override
  User user;
  BuildContext context;
  FinishSetupPaymentAccount({required this.user, required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class SendPayment extends PaymentsEvent {
  Proposal proposal;
  int amount;
  String description;
  User client;
  String freelancerStripeAccountId;
  String freelancerId;
  String freelancerName;
  String? milestoneName;
  String? milestoneId;
  String paymentType;

  BuildContext context;
  SendPayment(
      {required this.amount,
      required this.client,
      required this.freelancerStripeAccountId,
      required this.freelancerId,
      required this.freelancerName,
      this.milestoneName,
      this.milestoneId,
      required this.paymentType,
      required this.proposal,
      required this.description,
      required this.context});
  @override
  // TODO: implement props
  List<Object?> get props => [
        user,
        proposal,
        client,
        freelancerStripeAccountId,
        freelancerId,
        freelancerName,
        milestoneName,
        milestoneId,
        paymentType,
        description,
        amount
      ];
}
