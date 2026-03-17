import 'package:flutter/material.dart';

import '../../../../domain/entities/billing_entities.dart';

class BillingPlanBadge extends StatelessWidget {
  const BillingPlanBadge({super.key, required this.planCode, this.label});

  final BillingPlanCode planCode;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = switch (planCode) {
      BillingPlanCode.free => (
        background: scheme.surfaceContainerHighest,
        foreground: scheme.onSurface,
      ),
      BillingPlanCode.pro => (
        background: scheme.primary.withValues(alpha: 0.14),
        foreground: scheme.primary,
      ),
      BillingPlanCode.founding => (
        background: const Color(0xFFFFD99A).withValues(alpha: 0.24),
        foreground: const Color(0xFF8A4A00),
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: colors.background,
        border: Border.all(color: colors.foreground.withValues(alpha: 0.20)),
      ),
      child: Text(
        label ?? _labelFor(planCode),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _labelFor(BillingPlanCode planCode) {
  switch (planCode) {
    case BillingPlanCode.free:
      return 'Free';
    case BillingPlanCode.pro:
      return 'Pro';
    case BillingPlanCode.founding:
      return 'Founding';
  }
}
