import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../core/services/supabase_service.dart';
import '../../domain/entities/billing_entities.dart';

class BillingRemoteDataSource {
  const BillingRemoteDataSource();

  SupabaseClient get _client {
    final client = SupabaseService.client;
    if (client == null) {
      throw const AppException(
        'Supabase não configurado. Defina SUPABASE_URL e SUPABASE_ANON_KEY.',
      );
    }
    return client;
  }

  Future<BillingSnapshot> fetchSnapshot() async {
    final response = await _client.rpc('get_my_billing_snapshot');
    final data = _mapFromDynamic(response);
    if (data.isEmpty) {
      throw const AppException(
        'Snapshot de billing inválido retornado pelo servidor.',
      );
    }
    return BillingSnapshot.fromJson(data);
  }

  Future<BillingCheckoutSession> createCheckout(
    BillingPlanCode planCode,
  ) async {
    final data = await _invokeAuthenticated(
      'billing-create-checkout',
      body: {'planCode': planCode.name},
    );
    return BillingCheckoutSession.fromJson(data);
  }

  Future<String> createPortalSession() async {
    final data = await _invokeAuthenticated(
      'billing-create-portal-session',
      body: const <String, dynamic>{},
    );
    final url = data['url'] as String?;
    if (url == null || url.isEmpty) {
      throw const AppException(
        'Resposta inválida ao criar sessão de gerenciamento da assinatura.',
      );
    }
    return url;
  }

  Future<BillingSnapshot> cancelSubscription() async {
    final data = await _invokeAuthenticated(
      'billing-cancel-subscription',
      body: const <String, dynamic>{},
    );
    final snapshot = data['snapshot'];
    if (snapshot is! Map<String, dynamic>) {
      throw const AppException('Resposta inválida ao cancelar assinatura.');
    }
    return BillingSnapshot.fromJson(snapshot);
  }

  Future<BillingSnapshot> syncSubscription({
    String? gatewaySubscriptionId,
    String? paymentId,
  }) async {
    final body = <String, dynamic>{};
    if (gatewaySubscriptionId != null && gatewaySubscriptionId.isNotEmpty) {
      body['gatewaySubscriptionId'] = gatewaySubscriptionId;
    }
    if (paymentId != null && paymentId.isNotEmpty) {
      body['paymentId'] = paymentId;
    }

    final data = await _invokeAuthenticated(
      'billing-sync-subscription',
      body: body,
    );
    final snapshot = data['snapshot'];
    if (snapshot is! Map<String, dynamic>) {
      throw const AppException('Resposta inválida ao sincronizar assinatura.');
    }
    return BillingSnapshot.fromJson(snapshot);
  }

  Future<Map<String, dynamic>> _invokeAuthenticated(
    String functionName, {
    Object? body,
  }) async {
    final accessToken = await SupabaseService.requireAccessToken();

    try {
      final response = await _client.functions.invoke(
        functionName,
        headers: {'Authorization': 'Bearer $accessToken'},
        body: body,
      );
      return _mapFromDynamic(response.data);
    } on FunctionException catch (error) {
      throw _mapFunctionException(error);
    }
  }
}

Map<String, dynamic> _mapFromDynamic(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, dynamic item) => MapEntry(key.toString(), item));
  }
  return <String, dynamic>{};
}

AppException _mapFunctionException(FunctionException error) {
  if (error.status == 401) {
    return const AppException(
      'A cobrança foi recusada porque a sessão do app não foi autenticada corretamente. Faça login novamente e tente de novo.',
      code: 'billing_unauthorized',
    );
  }

  final details = _mapFromDynamic(error.details);
  final message =
      details['error'] as String? ??
      details['message'] as String? ??
      error.reasonPhrase;

  return AppException(
    message ?? 'Falha ao processar a operação de billing.',
    code: 'billing_function_error',
  );
}
