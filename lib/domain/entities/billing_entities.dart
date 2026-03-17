enum BillingPlanCode { free, pro, founding }

enum BillingSubscriptionStatus {
  trialing,
  active,
  pastDue,
  unpaid,
  canceled,
  expired,
  incomplete,
}

enum BillingFeatureKey {
  notesAccess('notes_access'),
  flashcardsAccess('flashcards_access'),
  mindMapsAccess('mind_maps_access'),
  analyticsAccess('analytics_access'),
  aiGeneration('ai_generation'),
  notesLimit('notes_limit'),
  projectsLimit('projects_limit'),
  flashcardsLimit('flashcards_limit'),
  mindMapsLimit('mind_maps_limit'),
  foundingBadge('founding_badge');

  const BillingFeatureKey(this.key);

  final String key;
}

class BillingFeatureEntitlement {
  const BillingFeatureEntitlement({
    required this.featureKey,
    required this.enabled,
    this.limitValue,
  });

  factory BillingFeatureEntitlement.fromJson(Map<String, dynamic> json) {
    return BillingFeatureEntitlement(
      featureKey: json['feature_key'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      limitValue: (json['limit_value'] as num?)?.toInt(),
    );
  }

  final String featureKey;
  final bool enabled;
  final int? limitValue;

  Map<String, dynamic> toJson() => {
    'feature_key': featureKey,
    'enabled': enabled,
    'limit_value': limitValue,
  };
}

class BillingPlanEntity {
  const BillingPlanEntity({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.priceCents,
    required this.currency,
    required this.interval,
    required this.isActive,
    required this.isPublic,
    required this.trialDays,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    this.features = const [],
  });

  factory BillingPlanEntity.fromJson(Map<String, dynamic> json) {
    return BillingPlanEntity(
      id: json['id'] as String? ?? '',
      code: _planCodeFromValue(json['code'] as String?),
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priceCents: (json['price_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'BRL',
      interval: json['interval'] as String? ?? 'month',
      isActive: json['is_active'] as bool? ?? false,
      isPublic: json['is_public'] as bool? ?? false,
      trialDays: (json['trial_days'] as num?)?.toInt() ?? 0,
      metadata: _mapFromDynamic(json['metadata']),
      createdAt: _dateFromDynamic(json['created_at']),
      updatedAt: _dateFromDynamic(json['updated_at']),
      features: _listFromDynamic(
        json['features'],
      ).map(BillingFeatureEntitlement.fromJson).toList(),
    );
  }

  final String id;
  final BillingPlanCode code;
  final String name;
  final String description;
  final int priceCents;
  final String currency;
  final String interval;
  final bool isActive;
  final bool isPublic;
  final int trialDays;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<BillingFeatureEntitlement> features;

  bool get isPremium => code != BillingPlanCode.free;
  bool get isFounding => code == BillingPlanCode.founding;

  Map<String, dynamic> toJson() => {
    'id': id,
    'code': code.name,
    'name': name,
    'description': description,
    'price_cents': priceCents,
    'currency': currency,
    'interval': interval,
    'is_active': isActive,
    'is_public': isPublic,
    'trial_days': trialDays,
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'features': features.map((item) => item.toJson()).toList(),
  };
}

class BillingCustomerEntity {
  const BillingCustomerEntity({
    required this.id,
    required this.gatewayProvider,
    required this.gatewayCustomerId,
    required this.billingEmail,
    required this.fullName,
    required this.taxDocument,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingCustomerEntity.fromJson(Map<String, dynamic> json) {
    return BillingCustomerEntity(
      id: json['id'] as String? ?? '',
      gatewayProvider: json['gateway_provider'] as String? ?? 'stripe',
      gatewayCustomerId: json['gateway_customer_id'] as String?,
      billingEmail: json['billing_email'] as String? ?? '',
      fullName: json['full_name'] as String? ?? '',
      taxDocument: json['tax_document'] as String?,
      metadata: _mapFromDynamic(json['metadata']),
      createdAt: _dateFromDynamic(json['created_at']),
      updatedAt: _dateFromDynamic(json['updated_at']),
    );
  }

  final String id;
  final String gatewayProvider;
  final String? gatewayCustomerId;
  final String billingEmail;
  final String fullName;
  final String? taxDocument;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'gateway_provider': gatewayProvider,
    'gateway_customer_id': gatewayCustomerId,
    'billing_email': billingEmail,
    'full_name': fullName,
    'tax_document': taxDocument,
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class BillingSubscriptionEntity {
  const BillingSubscriptionEntity({
    required this.id,
    required this.planId,
    required this.customerId,
    required this.gatewayProvider,
    required this.gatewaySubscriptionId,
    required this.externalReference,
    required this.status,
    required this.statusDetail,
    required this.billingCycle,
    required this.startedAt,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.cancelAtPeriodEnd,
    required this.canceledAt,
    required this.trialEndsAt,
    required this.graceUntil,
    required this.metadata,
    required this.createdAt,
    required this.updatedAt,
    required this.isPremium,
    required this.isTrialing,
    required this.isInGracePeriod,
    required this.hasLostAccess,
  });

  factory BillingSubscriptionEntity.fromJson(Map<String, dynamic> json) {
    return BillingSubscriptionEntity(
      id: json['id'] as String? ?? '',
      planId: json['plan_id'] as String? ?? '',
      customerId: json['customer_id'] as String?,
      gatewayProvider: json['gateway_provider'] as String? ?? 'stripe',
      gatewaySubscriptionId: json['gateway_subscription_id'] as String?,
      externalReference: json['external_reference'] as String?,
      status: _subscriptionStatusFromValue(json['status'] as String?),
      statusDetail: json['status_detail'] as String?,
      billingCycle: json['billing_cycle'] as String? ?? 'month',
      startedAt: _dateFromDynamic(json['started_at']),
      currentPeriodStart: _dateFromDynamic(json['current_period_start']),
      currentPeriodEnd: _dateFromDynamic(json['current_period_end']),
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
      canceledAt: _dateFromDynamic(json['canceled_at']),
      trialEndsAt: _dateFromDynamic(json['trial_ends_at']),
      graceUntil: _dateFromDynamic(json['grace_until']),
      metadata: _mapFromDynamic(json['metadata']),
      createdAt: _dateFromDynamic(json['created_at']),
      updatedAt: _dateFromDynamic(json['updated_at']),
      isPremium: json['is_premium'] as bool? ?? false,
      isTrialing: json['is_trialing'] as bool? ?? false,
      isInGracePeriod: json['is_in_grace_period'] as bool? ?? false,
      hasLostAccess: json['has_lost_access'] as bool? ?? false,
    );
  }

  final String id;
  final String planId;
  final String? customerId;
  final String gatewayProvider;
  final String? gatewaySubscriptionId;
  final String? externalReference;
  final BillingSubscriptionStatus status;
  final String? statusDetail;
  final String billingCycle;
  final DateTime? startedAt;
  final DateTime? currentPeriodStart;
  final DateTime? currentPeriodEnd;
  final bool cancelAtPeriodEnd;
  final DateTime? canceledAt;
  final DateTime? trialEndsAt;
  final DateTime? graceUntil;
  final Map<String, dynamic> metadata;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool isPremium;
  final bool isTrialing;
  final bool isInGracePeriod;
  final bool hasLostAccess;

  String? get checkoutUrl => metadata['checkout_url'] as String?;
  String? get managementUrl => metadata['management_url'] as String?;

  Map<String, dynamic> toJson() => {
    'id': id,
    'plan_id': planId,
    'customer_id': customerId,
    'gateway_provider': gatewayProvider,
    'gateway_subscription_id': gatewaySubscriptionId,
    'external_reference': externalReference,
    'status': _subscriptionStatusToValue(status),
    'status_detail': statusDetail,
    'billing_cycle': billingCycle,
    'started_at': startedAt?.toIso8601String(),
    'current_period_start': currentPeriodStart?.toIso8601String(),
    'current_period_end': currentPeriodEnd?.toIso8601String(),
    'cancel_at_period_end': cancelAtPeriodEnd,
    'canceled_at': canceledAt?.toIso8601String(),
    'trial_ends_at': trialEndsAt?.toIso8601String(),
    'grace_until': graceUntil?.toIso8601String(),
    'metadata': metadata,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    'is_premium': isPremium,
    'is_trialing': isTrialing,
    'is_in_grace_period': isInGracePeriod,
    'has_lost_access': hasLostAccess,
  };
}

class BillingPaymentEntity {
  const BillingPaymentEntity({
    required this.id,
    required this.subscriptionId,
    required this.gatewayProvider,
    required this.gatewayPaymentId,
    required this.externalReference,
    required this.amountCents,
    required this.currency,
    required this.status,
    required this.statusDetail,
    required this.paidAt,
    required this.invoiceUrl,
    required this.receiptUrl,
    required this.metadata,
    required this.rawPayload,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BillingPaymentEntity.fromJson(Map<String, dynamic> json) {
    return BillingPaymentEntity(
      id: json['id'] as String? ?? '',
      subscriptionId: json['subscription_id'] as String?,
      gatewayProvider: json['gateway_provider'] as String? ?? 'stripe',
      gatewayPaymentId: json['gateway_payment_id'] as String?,
      externalReference: json['external_reference'] as String?,
      amountCents: (json['amount_cents'] as num?)?.toInt() ?? 0,
      currency: json['currency'] as String? ?? 'BRL',
      status: json['status'] as String? ?? 'pending',
      statusDetail: json['status_detail'] as String?,
      paidAt: _dateFromDynamic(json['paid_at']),
      invoiceUrl: json['invoice_url'] as String?,
      receiptUrl: json['receipt_url'] as String?,
      metadata: _mapFromDynamic(json['metadata']),
      rawPayload: _mapFromDynamic(json['raw_payload']),
      createdAt: _dateFromDynamic(json['created_at']),
      updatedAt: _dateFromDynamic(json['updated_at']),
    );
  }

  final String id;
  final String? subscriptionId;
  final String gatewayProvider;
  final String? gatewayPaymentId;
  final String? externalReference;
  final int amountCents;
  final String currency;
  final String status;
  final String? statusDetail;
  final DateTime? paidAt;
  final String? invoiceUrl;
  final String? receiptUrl;
  final Map<String, dynamic> metadata;
  final Map<String, dynamic> rawPayload;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'subscription_id': subscriptionId,
    'gateway_provider': gatewayProvider,
    'gateway_payment_id': gatewayPaymentId,
    'external_reference': externalReference,
    'amount_cents': amountCents,
    'currency': currency,
    'status': status,
    'status_detail': statusDetail,
    'paid_at': paidAt?.toIso8601String(),
    'invoice_url': invoiceUrl,
    'receipt_url': receiptUrl,
    'metadata': metadata,
    'raw_payload': rawPayload,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}

class BillingConfigEntity {
  const BillingConfigEntity({
    required this.billingProvider,
    required this.trialEnabled,
    required this.trialDaysDefault,
    required this.foundingPlanEnabled,
  });

  factory BillingConfigEntity.fromJson(Map<String, dynamic> json) {
    return BillingConfigEntity(
      billingProvider: json['billing_provider'] as String? ?? 'stripe',
      trialEnabled: json['trial_enabled'] as bool? ?? false,
      trialDaysDefault: (json['trial_days_default'] as num?)?.toInt() ?? 0,
      foundingPlanEnabled: json['founding_plan_enabled'] as bool? ?? false,
    );
  }

  final String billingProvider;
  final bool trialEnabled;
  final int trialDaysDefault;
  final bool foundingPlanEnabled;

  Map<String, dynamic> toJson() => {
    'billing_provider': billingProvider,
    'trial_enabled': trialEnabled,
    'trial_days_default': trialDaysDefault,
    'founding_plan_enabled': foundingPlanEnabled,
  };
}

class BillingSnapshot {
  const BillingSnapshot({
    required this.customer,
    required this.subscription,
    required this.currentPlan,
    required this.availablePlans,
    required this.features,
    required this.payments,
    required this.foundingEligible,
    required this.config,
  });

  factory BillingSnapshot.fromJson(Map<String, dynamic> json) {
    return BillingSnapshot(
      customer: _nullableMapFromDynamic(json['customer']) == null
          ? null
          : BillingCustomerEntity.fromJson(
              _nullableMapFromDynamic(json['customer'])!,
            ),
      subscription: _nullableMapFromDynamic(json['subscription']) == null
          ? null
          : BillingSubscriptionEntity.fromJson(
              _nullableMapFromDynamic(json['subscription'])!,
            ),
      currentPlan: _nullableMapFromDynamic(json['current_plan']) == null
          ? null
          : BillingPlanEntity.fromJson(
              _nullableMapFromDynamic(json['current_plan'])!,
            ),
      availablePlans: _listFromDynamic(
        json['available_plans'],
      ).map(BillingPlanEntity.fromJson).toList(),
      features: _listFromDynamic(
        json['features'],
      ).map(BillingFeatureEntitlement.fromJson).toList(),
      payments: _listFromDynamic(
        json['payments'],
      ).map(BillingPaymentEntity.fromJson).toList(),
      foundingEligible: json['founding_eligible'] as bool? ?? false,
      config: BillingConfigEntity.fromJson(_mapFromDynamic(json['config'])),
    );
  }

  factory BillingSnapshot.fallbackFree() {
    const freePlan = BillingPlanEntity(
      id: 'free',
      code: BillingPlanCode.free,
      name: 'Free',
      description: 'Acesso básico ao produto.',
      priceCents: 0,
      currency: 'BRL',
      interval: 'month',
      isActive: true,
      isPublic: true,
      trialDays: 0,
      metadata: {'badge': 'Free'},
      createdAt: null,
      updatedAt: null,
      features: [
        BillingFeatureEntitlement(featureKey: 'notes_access', enabled: true),
        BillingFeatureEntitlement(
          featureKey: 'flashcards_access',
          enabled: false,
        ),
        BillingFeatureEntitlement(
          featureKey: 'mind_maps_access',
          enabled: false,
        ),
        BillingFeatureEntitlement(
          featureKey: 'analytics_access',
          enabled: false,
        ),
        BillingFeatureEntitlement(featureKey: 'ai_generation', enabled: false),
        BillingFeatureEntitlement(
          featureKey: 'notes_limit',
          enabled: true,
          limitValue: 40,
        ),
        BillingFeatureEntitlement(
          featureKey: 'projects_limit',
          enabled: true,
          limitValue: 3,
        ),
        BillingFeatureEntitlement(
          featureKey: 'flashcards_limit',
          enabled: false,
          limitValue: 0,
        ),
        BillingFeatureEntitlement(
          featureKey: 'mind_maps_limit',
          enabled: false,
          limitValue: 0,
        ),
      ],
    );

    return BillingSnapshot(
      customer: null,
      subscription: null,
      currentPlan: freePlan,
      availablePlans: [freePlan],
      features: freePlan.features,
      payments: [],
      foundingEligible: false,
      config: const BillingConfigEntity(
        billingProvider: 'stripe',
        trialEnabled: false,
        trialDaysDefault: 0,
        foundingPlanEnabled: false,
      ),
    );
  }

  final BillingCustomerEntity? customer;
  final BillingSubscriptionEntity? subscription;
  final BillingPlanEntity? currentPlan;
  final List<BillingPlanEntity> availablePlans;
  final List<BillingFeatureEntitlement> features;
  final List<BillingPaymentEntity> payments;
  final bool foundingEligible;
  final BillingConfigEntity config;

  BillingPlanCode get currentPlanCode =>
      currentPlan?.code ?? BillingPlanCode.free;

  bool get isPremium =>
      subscription?.isPremium ?? currentPlanCode != BillingPlanCode.free;
  bool get isTrialing => subscription?.isTrialing ?? false;
  bool get isFounding => currentPlanCode == BillingPlanCode.founding;
  bool get hasLostPremiumAccess => subscription?.hasLostAccess ?? false;

  BillingFeatureEntitlement entitlementFor(String featureKey) {
    for (final item in features) {
      if (item.featureKey == featureKey) {
        return item;
      }
    }
    return BillingFeatureEntitlement(featureKey: featureKey, enabled: false);
  }

  bool hasFeature(BillingFeatureKey featureKey) {
    return entitlementFor(featureKey.key).enabled;
  }

  int? limitFor(BillingFeatureKey featureKey) {
    return entitlementFor(featureKey.key).limitValue;
  }

  BillingPlanEntity? get proPlan {
    for (final plan in availablePlans) {
      if (plan.code == BillingPlanCode.pro) return plan;
    }
    return null;
  }

  BillingPlanEntity? get foundingPlan {
    for (final plan in availablePlans) {
      if (plan.code == BillingPlanCode.founding) return plan;
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'customer': customer?.toJson(),
    'subscription': subscription?.toJson(),
    'current_plan': currentPlan?.toJson(),
    'available_plans': availablePlans.map((item) => item.toJson()).toList(),
    'features': features.map((item) => item.toJson()).toList(),
    'payments': payments.map((item) => item.toJson()).toList(),
    'founding_eligible': foundingEligible,
    'config': config.toJson(),
  };
}

class BillingCheckoutSession {
  const BillingCheckoutSession({
    required this.checkoutUrl,
    required this.managementUrl,
    required this.subscriptionId,
    required this.snapshot,
  });

  factory BillingCheckoutSession.fromJson(Map<String, dynamic> json) {
    return BillingCheckoutSession(
      checkoutUrl: json['checkoutUrl'] as String?,
      managementUrl: json['managementUrl'] as String?,
      subscriptionId: json['subscriptionId'] as String?,
      snapshot: BillingSnapshot.fromJson(_mapFromDynamic(json['snapshot'])),
    );
  }

  final String? checkoutUrl;
  final String? managementUrl;
  final String? subscriptionId;
  final BillingSnapshot snapshot;
}

class FeatureAccessDecision {
  const FeatureAccessDecision({
    required this.allowed,
    required this.featureKey,
    required this.message,
    required this.ctaLabel,
    required this.currentPlanCode,
    required this.requiredPlanCode,
    this.limitValue,
    this.usedCount,
  });

  final bool allowed;
  final String featureKey;
  final String message;
  final String ctaLabel;
  final BillingPlanCode currentPlanCode;
  final BillingPlanCode requiredPlanCode;
  final int? limitValue;
  final int? usedCount;
}

BillingPlanCode _planCodeFromValue(String? value) {
  switch (value) {
    case 'pro':
      return BillingPlanCode.pro;
    case 'founding':
      return BillingPlanCode.founding;
    default:
      return BillingPlanCode.free;
  }
}

BillingSubscriptionStatus _subscriptionStatusFromValue(String? value) {
  switch (value) {
    case 'trialing':
      return BillingSubscriptionStatus.trialing;
    case 'past_due':
      return BillingSubscriptionStatus.pastDue;
    case 'unpaid':
      return BillingSubscriptionStatus.unpaid;
    case 'canceled':
      return BillingSubscriptionStatus.canceled;
    case 'expired':
      return BillingSubscriptionStatus.expired;
    case 'incomplete':
      return BillingSubscriptionStatus.incomplete;
    default:
      return BillingSubscriptionStatus.active;
  }
}

String _subscriptionStatusToValue(BillingSubscriptionStatus status) {
  switch (status) {
    case BillingSubscriptionStatus.trialing:
      return 'trialing';
    case BillingSubscriptionStatus.pastDue:
      return 'past_due';
    case BillingSubscriptionStatus.unpaid:
      return 'unpaid';
    case BillingSubscriptionStatus.canceled:
      return 'canceled';
    case BillingSubscriptionStatus.expired:
      return 'expired';
    case BillingSubscriptionStatus.incomplete:
      return 'incomplete';
    case BillingSubscriptionStatus.active:
      return 'active';
  }
}

DateTime? _dateFromDynamic(dynamic value) {
  if (value is! String || value.isEmpty) return null;
  return DateTime.tryParse(value)?.toLocal();
}

Map<String, dynamic> _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, dynamic item) => MapEntry(key.toString(), item));
  }
  return <String, dynamic>{};
}

Map<String, dynamic>? _nullableMapFromDynamic(dynamic value) {
  if (value == null) return null;
  return _mapFromDynamic(value);
}

List<Map<String, dynamic>> _listFromDynamic(dynamic value) {
  if (value is! List) return const [];
  return value.map((item) => _mapFromDynamic(item)).toList();
}
