$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $projectRoot "env\supabase.local.json"

function Resolve-FlutterCommand {
  $localFlutter = Join-Path (Split-Path -Parent $projectRoot) "flutter\bin\flutter.bat"
  if (Test-Path $localFlutter) {
    return $localFlutter
  }

  $flutterFromPath = Get-Command flutter -ErrorAction SilentlyContinue
  if ($flutterFromPath) {
    return $flutterFromPath.Source
  }

  throw "Flutter nao encontrado. Instale o Flutter ou deixe-o disponivel no PATH."
}

function Assert-WindowsDesktopToolchain {
  $vsWhere = Join-Path "${env:ProgramFiles(x86)}" "Microsoft Visual Studio\Installer\vswhere.exe"
  if (-not (Test-Path $vsWhere)) {
    throw @"
Visual Studio 2022 nao encontrado.
Instale o Visual Studio 2022 Community ou Build Tools com o workload:
- Desktop development with C++
"@
  }

  $installationPath = & $vsWhere `
    -latest `
    -products * `
    -requires Microsoft.VisualStudio.Workload.NativeDesktop `
    -property installationPath

  if (-not $installationPath) {
    throw @"
Visual Studio encontrado, mas sem a toolchain necessaria para Flutter Windows.
Abra o Visual Studio Installer e adicione:
- Desktop development with C++
"@
  }
}

Push-Location $projectRoot
try {
  Assert-WindowsDesktopToolchain
  $flutterSdk = Resolve-FlutterCommand

  $args = @("run", "-d", "windows")
  if (Test-Path $envFile) {
    $args += "--dart-define-from-file=$envFile"
  }
  & $flutterSdk @args
}
finally {
  Pop-Location
}
