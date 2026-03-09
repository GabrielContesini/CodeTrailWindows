class AppEnv {
  const AppEnv._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const commandCenterUrl = String.fromEnvironment('COMMAND_CENTER_URL');
  static const commandCenterIngestToken = String.fromEnvironment(
    'COMMAND_CENTER_INGEST_TOKEN',
  );
  static const appEnvironment = String.fromEnvironment(
    'APP_ENVIRONMENT',
    defaultValue: 'production',
  );
  static const releaseChannel = String.fromEnvironment(
    'RELEASE_CHANNEL',
    defaultValue: 'stable',
  );

  static bool get isSupabaseConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get isCommandCenterConfigured =>
      commandCenterUrl.isNotEmpty && commandCenterIngestToken.isNotEmpty;
}
