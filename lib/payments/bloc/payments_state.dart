part of 'payments_bloc.dart';

// TODO: Create pending stripe account state
enum StripeAccountStatus { notCreated, incomplete, complete }

class PaymentsState extends Equatable {
  final StripeAccount? stripeAccount;
  final String? loginLink;
  final StripeAccountStatus? stripeAccountStatus;
  final Balance? balance;
  final List<BalanceTransaction>? balanceTransactions;
  final List<Charge>? charges;
  const PaymentsState({
    this.stripeAccount,
    this.stripeAccountStatus,
    this.loginLink,
    this.balance,
    this.balanceTransactions,
    this.charges,
  });

  @override
  List<Object?> get props => [
        stripeAccount,
        stripeAccountStatus,
        loginLink,
        balance,
        balanceTransactions,
        charges
      ];

  // copyWith
  PaymentsState copyWith({
    StripeAccount? stripeAccount,
    StripeAccountStatus? stripeAccountStatus,
    String? loginLink,
    Balance? balance,
    List<BalanceTransaction>? balanceTransactions,
    List<Charge>? charges,
  }) {
    return PaymentsState(
      stripeAccount: stripeAccount ?? this.stripeAccount,
      stripeAccountStatus: stripeAccountStatus ?? this.stripeAccountStatus,
      loginLink: loginLink ?? this.loginLink,
      balance: balance ?? this.balance,
      balanceTransactions: balanceTransactions ?? this.balanceTransactions,
      charges: charges ?? this.charges,
    );
  }
}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  @override
  final StripeAccount? stripeAccount;
  @override
  final String? loginLink;
  @override
  final StripeAccountStatus? stripeAccountStatus;
  @override
  final Balance? balance;
  @override
  final List<BalanceTransaction>? balanceTransactions;
  @override
  final List<Charge>? charges;
  const PaymentsLoaded(
      {this.stripeAccount,
      this.loginLink,
      this.stripeAccountStatus,
      this.balance,
      this.balanceTransactions,
      this.charges});
  @override
  // TODO: implement props
  List<Object?> get props => [
        stripeAccount,
        loginLink,
        stripeAccountStatus,
        balance,
        balanceTransactions,
        charges
      ];
}

class PaymentsError extends PaymentsState {
  final String message;
  const PaymentsError({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class PaymentSent extends PaymentsState {}
