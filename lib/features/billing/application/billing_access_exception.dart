import '../../../core/errors/app_exception.dart';
import '../../../domain/entities/billing_entities.dart';

class BillingAccessException extends AppException {
  BillingAccessException(this.decision)
    : super(decision.message, code: 'billing_access_denied');

  final FeatureAccessDecision decision;
}
