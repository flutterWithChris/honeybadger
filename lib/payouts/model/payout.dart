enum PayoutMethod { instant, standard }

enum SourceType { card, fpx, bankAccount }

class Payout {
  String? id;
  int? amount;
  DateTime? arrivalDate;
  bool? automatic;
  String? balanceTransaction;
  DateTime? created;
  String? currency;
  String? description;
  String? destination;
  String? failureBalanceTransaction;
  String? failureCode;
  String? failureMessage;
  bool? livemode;
  Map? metadata;
  PayoutMethod? method;
  String? originalPayout;
  String? reconciliationStatus;
  String? reversedBy;
  SourceType? sourceType;
  String? statementDescriptor;
  String? status;
  String? type;

  Payout(
      {this.id,
      this.amount,
      this.arrivalDate,
      this.automatic,
      this.balanceTransaction,
      this.created,
      this.currency,
      this.description,
      this.destination,
      this.failureBalanceTransaction,
      this.failureCode,
      this.failureMessage,
      this.livemode,
      this.metadata,
      this.method,
      this.originalPayout,
      this.reconciliationStatus,
      this.reversedBy,
      this.sourceType,
      this.statementDescriptor,
      this.status,
      this.type});

  Payout.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    amount = json['amount'];
    arrivalDate = json['arrival_date'];
    automatic = json['automatic'];
    balanceTransaction = json['balance_transaction'];
    created = json['created'];
    currency = json['currency'];
    description = json['description'];
    destination = json['destination'];
    failureBalanceTransaction = json['failure_balance_transaction'];
    failureCode = json['failure_code'];
    failureMessage = json['failure_message'];
    livemode = json['livemode'];
    metadata = json['metadata'];
    method = json['method'] == 'instant'
        ? PayoutMethod.instant
        : PayoutMethod.standard;
    originalPayout = json['original_payout'];
    reconciliationStatus = json['reconciliation_status'];
    reversedBy = json['reversed_by'];
    sourceType = json['source_type'] == 'card'
        ? SourceType.card
        : json['source_type'] == 'fpx'
            ? SourceType.fpx
            : SourceType.bankAccount;
    statementDescriptor = json['statement_descriptor'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['amount'] = amount;
    data['arrival_date'] = arrivalDate;
    data['automatic'] = automatic;
    data['balance_transaction'] = balanceTransaction;
    data['created'] = created;
    data['currency'] = currency;
    data['description'] = description;
    data['destination'] = destination;
    data['failure_balance_transaction'] = failureBalanceTransaction;
    data['failure_code'] = failureCode;
    data['failure_message'] = failureMessage;
    data['livemode'] = livemode;
    data['metadata'] = metadata;
    data['method'] = method == PayoutMethod.instant ? 'instant' : 'standard';
    data['original_payout'] = originalPayout;
    data['reconciliation_status'] = reconciliationStatus;
    data['reversed_by'] = reversedBy;
    data['source_type'] = sourceType == SourceType.card
        ? 'card'
        : sourceType == SourceType.fpx
            ? 'fpx'
            : 'bank_account';
    data['statement_descriptor'] = statementDescriptor;
    data['status'] = status;
    data['type'] = type;
    return data;
  }
}
