import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/services/service_providers.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_logo.dart';
import '../application/auth_controller.dart';
import 'widgets/auth_workspace_shell.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  String? _feedbackMessage;
  bool _feedbackIsError = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadPreferences);
  }

  Future<void> _loadPreferences() async {
    final preferences = ref.read(sessionPreferencesProvider);
    final email = await preferences.getLastEmail();
    final rememberMe = await preferences.getRememberMe();

    if (!mounted) {
      return;
    }

    setState(() {
      if (email != null && _emailController.text.isEmpty) {
        _emailController.text = email;
      }
      _rememberMe = rememberMe ?? true;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (_, next) {
      next.whenOrNull(
        error: (error, _) async {
          final message = error.toString();
          if (!context.mounted) {
            return;
          }
          _showFeedback(message, isError: true);
          if (message.toLowerCase().contains('confirme seu e-mail')) {
            await showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('Confirme seu e-mail'),
                content: const Text(
                  'Seu cadastro existe, mas ainda falta confirmar o e-mail. '
                  'Abra a mensagem enviada pelo Supabase e valide sua conta antes de entrar.',
                ),
                actions: [
                  FilledButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Entendi'),
                  ),
                ],
              ),
            );
            return;
          }
        },
      );
    });

    return AuthWorkspaceShell(
      showcaseTitle: 'Entre no seu workspace de estudo.',
      showcaseSubtitle:
          'A versão Windows agora abre como uma central de operação. O login continua manual; se você quiser, o app lembra apenas o e-mail desta máquina.',
      form: AuthFormCard(
        eyebrow: 'Login manual',
        title: 'Entrar',
        subtitle: 'Supabase Auth com sessão segura e abertura do workspace.',
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppLogo(size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Use sua conta para voltar ao plano, às tarefas e ao histórico de foco.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: (value) => (value == null || value.trim().isEmpty)
                    ? 'Informe o e-mail'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  suffixIcon: IconButton(
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
                validator: (value) => (value == null || value.length < 6)
                    ? 'Senha inválida'
                    : null,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: Theme.of(
                    context,
                  ).colorScheme.secondary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? true),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lembrar e-mail',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Mantém apenas o e-mail preenchido. O login segue manual.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_feedbackMessage != null) ...[
                _InlineFeedbackCard(
                  message: _feedbackMessage!,
                  isError: _feedbackIsError,
                ),
                const SizedBox(height: 14),
              ],
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          try {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            final success = await ref
                                .read(authControllerProvider.notifier)
                                .signIn(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text,
                                  rememberMe: _rememberMe,
                                );
                            if (!context.mounted || !success) {
                              return;
                            }
                            _showFeedback(
                              'Login aceito. Finalizando abertura do workspace...',
                              isError: false,
                            );
                            final route = await ref
                                .read(startupCoordinatorProvider)
                                .resolvePostLoginRoute();
                            if (!context.mounted) {
                              return;
                            }
                            if (route == AppRoutes.login) {
                              _showFeedback(
                                'A sessão não ficou válida após o login. Tente novamente.',
                                isError: true,
                              );
                              return;
                            }
                            context.go(route);
                          } catch (error) {
                            if (!context.mounted) {
                              return;
                            }
                            _showFeedback(
                              'Falha ao abrir o app após o login: $error',
                              isError: true,
                            );
                          }
                        },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: Text(
                    authState.isLoading
                        ? 'Entrando...'
                        : 'Entrar no workspace',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  TextButton(
                    onPressed: () => context.go(AppRoutes.signup),
                    child: const Text('Criar conta'),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        context.showAppSnackBar(
                          'Informe o e-mail para recuperar a senha.',
                        );
                        return;
                      }
                      final success = await ref
                          .read(authControllerProvider.notifier)
                          .resetPassword(email);
                      if (!context.mounted || !success) {
                        return;
                      }
                      context.showAppSnackBar('Link de recuperação enviado.');
                    },
                    child: const Text('Recuperar senha'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFeedback(String message, {required bool isError}) {
    if (!mounted) {
      return;
    }

    setState(() {
      _feedbackMessage = message;
      _feedbackIsError = isError;
    });
    context.showAppSnackBar(message);
  }
}

class _InlineFeedbackCard extends StatelessWidget {
  const _InlineFeedbackCard({
    required this.message,
    required this.isError,
  });

  final String message;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    final color = isError
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.secondary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        color: color.withValues(alpha: 0.12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline_rounded : Icons.check_circle_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
