$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot

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
  $payload = @{}
  $candidateFiles = @(
    (Join-Path $projectRoot "env\supabase.github.json"),
    (Join-Path $projectRoot "env\supabase.local.json"),
    (Join-Path $projectRoot "env\command_center.local.json")
  )
  foreach ($candidateFile in $candidateFiles) {
    if (Test-Path $candidateFile) {
      $data = Get-Content $candidateFile -Raw | ConvertFrom-Json -AsHashtable
      foreach ($entry in $data.GetEnumerator()) {
        $payload[$entry.Key] = $entry.Value
      }
    }
  }
  foreach ($name in @(
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
    "COMMAND_CENTER_URL",
    "COMMAND_CENTER_INGEST_TOKEN",
    "APP_ENVIRONMENT",
    "RELEASE_CHANNEL"
  )) {
    $value = [Environment]::GetEnvironmentVariable($name)
    if ($value) {
      $payload[$name] = $value
    }
  }
  if ($payload.Count -gt 0) {
    $generatedEnvFile = Join-Path $projectRoot "env\runtime.generated.json"
    Set-Content -Path $generatedEnvFile -Value ($payload | ConvertTo-Json -Compress) -Encoding ASCII
    $args += "--dart-define-from-file=$generatedEnvFile"
  }
  & $flutterSdk @args
}
finally {
  if (Test-Path ".\env\runtime.generated.json") {
    Remove-Item ".\env\runtime.generated.json" -Force
  }
  Pop-Location
}
