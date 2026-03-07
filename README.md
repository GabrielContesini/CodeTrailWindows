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
4. `env/supabase.local.json` configurado opcionalmente

Para habilitar `Developer Mode`:

```powershell
start ms-settings:developers
```

## Rodar no Windows

```powershell
.\scripts\run_windows.ps1
```

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

## Observação

Esta entrega prepara a base técnica do desktop. O próximo passo natural é refinar layout, densidade, tipografia e navegação especificamente para Windows.
