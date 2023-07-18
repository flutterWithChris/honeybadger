enum PaymentStatus { pending, paid, failed }

enum PaymentType { fixed, hourly }

class Payment {
  String? id;
  PaymentStatus? status;
  PaymentType? type;
  String? payerId;
  String? payerName;
  String? payeeId;
  String? payeeName;
  String? paymentDate;
  double? amount;
  double? hours;
  String? currency;
  String? description;
  String? milestoneId;
  String? milestoneTitle;
  String? projectId;
  String? projectTitle;

  Payment(
      {this.id,
      this.status,
      this.type,
      this.payerId,
      this.payerName,
      this.payeeId,
      this.payeeName,
      this.paymentDate,
      this.amount,
      this.hours,
      this.currency,
      this.description,
      this.milestoneId,
      this.milestoneTitle,
      this.projectId,
      this.projectTitle});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'] == 'pending'
        ? PaymentStatus.pending
        : json['status'] == 'paid'
            ? PaymentStatus.paid
            : PaymentStatus.failed;
    type = json['type'] == 'fixed'
        ? PaymentType.fixed
        : json['type'] == 'hourly'
            ? PaymentType.hourly
            : null;
    payerId = json['payer_id'];
    payerName = json['payer_name'];
    payeeId = json['payee_id'];
    payeeName = json['payee_name'];
    paymentDate = json['payment_date'];
    amount = json['amount'];
    hours = json['hours'];
    currency = json['currency'];
    description = json['description'];
    milestoneId = json['milestone_id'];
    milestoneTitle = json['milestone_title'];
    projectId = json['project_id'];
    projectTitle = json['project_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['status'] = status == PaymentStatus.pending
        ? 'pending'
        : status == PaymentStatus.paid
            ? 'paid'
            : 'failed';
    data['type'] = type == PaymentType.fixed
        ? 'fixed'
        : type == PaymentType.hourly
            ? 'hourly'
            : null;
    data['payer_id'] = payerId;
    data['payer_name'] = payerName;
    data['payee_id'] = payeeId;
    data['payee_name'] = payeeName;
    data['payment_date'] = paymentDate;
    data['amount'] = amount;
    data['hours'] = hours;
    data['currency'] = currency;
    data['description'] = description;
    data['milestone_id'] = milestoneId;
    data['milestone_title'] = milestoneTitle;
    data['project_id'] = projectId;
    data['project_title'] = projectTitle;
    return data;
  }
}
