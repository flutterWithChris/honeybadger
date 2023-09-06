class StripeAccount {
  final String? id;
  final String? businessType;
  final Map<String, String>? capabilities;
  final Map<String, dynamic>? company;
  final String? country;
  final String? email;
  final Map<String, dynamic>? individual;
  final Map<String, String>? metadata;
  final Map<String, dynamic>? requirements;
  final Map<String, dynamic>? tosAcceptance;
  final String? type;
  final Map<String, dynamic>? businessProfile;
  final bool? chargesEnabled;
  final Map<String, dynamic>? controller;
  final int? created;
  final String? defaultCurrency;
  final bool? detailsSubmitted;
  final Map<String, dynamic>? externalAccounts;
  final Map<String, dynamic>? futureRequirements;
  final bool? payoutsEnabled;
  final Map<String, dynamic>? settings;
  final List<dynamic>? availablePayoutMethods;

  StripeAccount({
    this.id,
    this.businessType,
    this.capabilities,
    this.company,
    this.country,
    this.email,
    this.individual,
    this.metadata,
    this.requirements,
    this.tosAcceptance,
    this.type,
    this.businessProfile,
    this.chargesEnabled,
    this.controller,
    this.created,
    this.defaultCurrency,
    this.detailsSubmitted,
    this.externalAccounts,
    this.futureRequirements,
    this.payoutsEnabled,
    this.settings,
    this.availablePayoutMethods,
  });

  factory StripeAccount.fromJson(Map<String, dynamic> json) {
    var externalAccountsData = json['external_accounts']['data'] as List?;
    var availablePayoutMethodsList = externalAccountsData
        ?.map((data) => data['available_payout_methods'] as List<dynamic>?)
        .toList();
    return StripeAccount(
      id: json['id'],
      businessType: json['business_type'],
      capabilities: Map<String, String>.from(json['capabilities'] ?? {}),
      company: json['company'] as Map<String, dynamic>?,
      country: json['country'],
      email: json['email'],
      individual: json['individual'] as Map<String, dynamic>?,
      metadata: Map<String, String>.from(json['metadata'] ?? {}),
      requirements: json['requirements'] as Map<String, dynamic>?,
      tosAcceptance: json['tos_acceptance'] as Map<String, dynamic>?,
      type: json['type'],
      businessProfile: json['business_profile'] as Map<String, dynamic>?,
      chargesEnabled: json['charges_enabled'],
      controller: json['controller'] as Map<String, dynamic>?,
      created: json['created'],
      defaultCurrency: json['default_currency'],
      detailsSubmitted: json['details_submitted'],
      externalAccounts: json['external_accounts'] as Map<String, dynamic>?,
      futureRequirements: json['future_requirements'] as Map<String, dynamic>?,
      payoutsEnabled: json['payouts_enabled'],
      settings: json['settings'] as Map<String, dynamic>?,
      availablePayoutMethods: externalAccountsData != null &&
              externalAccountsData.isNotEmpty
          ? externalAccountsData[0]['available_payout_methods'] as List<dynamic>
          : null,
    );
  }
}
