# CodeTrail Windows

Projeto desktop separado do CodeTrail, baseado na versão estável Android e preparado para iterações específicas de Windows sem afetar o app tablet.

## O que já veio reaproveitado

- arquitetura em camadas
- Supabase
- Drift offline-first
- Riverpod
- go_router
- dashboard, trilhas, tarefas, revisões, projetos, notas e analytics

## Ajustes específicos de Windows já aplicados

- projeto Flutter próprio em `CodeTrailWindows/`
- executável com nome `CodeTrailWindows.exe`
- título inicial `CodeTrail Windows`
- banco local separado: `code_trail_windows.sqlite`
- notificações adaptadas para Windows e Android
- scripts próprios de execução e build

## Pré-requisitos

1. Visual Studio 2022 com workload `Desktop development with C++`
2. Flutter estável
3. Windows `Developer Mode` habilitado
4. `env/supabase.local.json` configurado opcionalmente para sobrescrever o ambiente publico de release
5. `env/command_center.local.json` opcional se voce quiser ativar heartbeat local para o Command Center

Para habilitar `Developer Mode`:

```powershell
start ms-settings:developers
```

## Rodar no Windows

```powershell
.\scripts\run_windows.ps1
```

Se quiser ligar heartbeat real para o Command Center durante o desenvolvimento:

1. copie [env/command_center.example.json](./env/command_center.example.json) para `env/command_center.local.json`
2. preencha:
   - `COMMAND_CENTER_URL`
   - `COMMAND_CENTER_INGEST_TOKEN`
   - opcionalmente `APP_ENVIRONMENT`
   - opcionalmente `RELEASE_CHANNEL`

## Gerar bundle Windows

```powershell
.\scripts\build_windows_release.ps1
```

Saídas:

- pasta do bundle: `artifacts/release/CodeTrailWindows-<versao+build>-release/`
- zip portátil: `artifacts/release/CodeTrailWindows-<versao+build>-release.zip`

## Gerar instalador Windows

Pré-requisito:

- Inno Setup 6 instalado

Comando:

```powershell
.\scripts\build_windows_installer.ps1
```

Saída:

- `artifacts/installer/CodeTrailWindows-<versao+build>-setup.exe`

## Atualizações para seus amigos

O app Windows agora verifica novas versões no GitHub Releases do repositório:

- `GabrielContesini/CodeTrailWindows`

Fluxo esperado:

1. publique uma nova release no GitHub com tag no formato `vX.Y.Z`
2. anexe o instalador `CodeTrailWindows-<versao+build>-setup.exe`
3. quando o usuário abrir o app, o CodeTrail consulta a release mais recente
4. se houver versão nova, ele oferece `Ver mudanças` ou `Atualizar agora`
5. ao escolher atualizar, o app baixa o `setup.exe` e inicia o instalador

Observações:

- o updater procura um asset `.exe` com `setup` no nome
- a comparação usa a versão do app instalada, por exemplo `1.1.0`
- para checar manualmente, use `Configurações > Atualizações`
- builds de release no GitHub Actions usam `env/supabase.github.json`, então o ciclo automático não depende de secrets privados para a chave publica do cliente

## Heartbeat real para o Command Center

O app Windows agora consegue enviar heartbeat real para o endpoint:

- `POST /api/telemetry/heartbeat`

Quando `COMMAND_CENTER_URL` e `COMMAND_CENTER_INGEST_TOKEN` estiverem configurados, o cliente:

1. gera um `instanceId` persistente
2. envia heartbeat ao abrir
3. envia heartbeat quando a sessao muda
4. envia heartbeat quando a conectividade volta
5. continua enviando heartbeat periodico em background

O payload inclui:

- usuario autenticado atual, se existir
- versao instalada
- backlog e erros da fila local de sync
- hostname da maquina
- ambiente e canal de release
- uptime do app

## GitHub Actions para release

O workflow de release do Windows já consegue gerar e publicar o instalador automaticamente sem secrets extras, porque usa o arquivo versionado `env/supabase.github.json` com as chaves publicas do cliente.

Fluxo:

1. atualize a versão no `pubspec.yaml`
2. crie uma tag no formato `vX.Y.Z`
3. faça push da tag
4. o GitHub Actions compila o bundle, gera o `setup.exe` e anexa os arquivos na GitHub Release

Observação:

- em push por tag, o workflow valida se a tag bate com o `build-name` do `pubspec.yaml`

Se quiser sobrescrever o ambiente no seu PC local, mantenha `env/supabase.local.json`. Os scripts preferem:

1. `env/supabase.github.json`
2. `env/supabase.local.json`
3. `env/command_center.local.json`
4. variaveis de ambiente do processo atual

Para o pipeline de release publicar builds com heartbeat ativo, configure no repositório `CodeTrailWindows`:

- `Repository variable`: `COMMAND_CENTER_URL`
- `Repository secret`: `COMMAND_CENTER_INGEST_TOKEN`

## Observação

Esta entrega prepara a base técnica do desktop. O próximo passo natural é refinar layout, densidade, tipografia e navegação especificamente para Windows.
