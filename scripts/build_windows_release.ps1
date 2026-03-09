$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$iconGeneratorScript = Join-Path $PSScriptRoot "generate_windows_icon.ps1"

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

function Get-AppVersionInfo {
  $versionLine = Get-Content ".\pubspec.yaml" |
    Where-Object { $_ -match '^version:\s*([^\s]+)$' } |
    Select-Object -First 1

  if (-not $versionLine) {
    throw "Nao foi possivel encontrar a versao no pubspec.yaml."
  }

  $rawVersion = (($versionLine -split ':\s*', 2)[1]).Trim()

  if ($rawVersion -notmatch '^(?<buildName>\d+\.\d+\.\d+)\+(?<buildNumber>\d+)$') {
    throw "A versao '$rawVersion' nao esta no formato esperado buildName+buildNumber."
  }

  return [PSCustomObject]@{
    BuildName = $Matches.buildName
    BuildNumber = $Matches.buildNumber
    FullVersion = "$($Matches.buildName)+$($Matches.buildNumber)"
  }
}

function Get-UniqueArtifactBasePath {
  param(
    [string]$Directory,
    [string]$BaseName
  )

  New-Item -ItemType Directory -Path $Directory -Force | Out-Null

  $candidate = Join-Path $Directory $BaseName
  $revision = 1

  while ((Test-Path $candidate) -or (Test-Path "$candidate.zip")) {
    $revision += 1
    $candidate = Join-Path $Directory "$BaseName-r$revision"
  }

  return $candidate
}

function Resolve-DartDefineArgument {
  $payload = @{}

  $candidateFiles = @(
    (Join-Path $projectRoot "env\supabase.github.json"),
    (Join-Path $projectRoot "env\supabase.local.json"),
    (Join-Path $projectRoot "env\command_center.local.json")
  )

  foreach ($candidateFile in $candidateFiles) {
    if (-not (Test-Path $candidateFile)) {
      continue
    }

    $data = Get-Content $candidateFile -Raw | ConvertFrom-Json -AsHashtable
    foreach ($entry in $data.GetEnumerator()) {
      $payload[$entry.Key] = $entry.Value
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

  if ($payload.Count -eq 0) {
    return $null
  }

  $generatedEnvFile = Join-Path $projectRoot "env\runtime.generated.json"
  Set-Content -Path $generatedEnvFile -Value ($payload | ConvertTo-Json -Compress) -Encoding ASCII
  return "--dart-define-from-file=$generatedEnvFile"
}

Push-Location $projectRoot
try {
  Assert-WindowsDesktopToolchain
  $flutterSdk = Resolve-FlutterCommand
  & $iconGeneratorScript

  if (Test-Path ".\build\windows") {
    Remove-Item ".\build\windows" -Recurse -Force
  }

  $version = Get-AppVersionInfo
  $artifactDir = ".\artifacts\release"
  $artifactBase = Get-UniqueArtifactBasePath `
    -Directory $artifactDir `
    -BaseName "CodeTrailWindows-$($version.FullVersion)-release"

  $args = @(
    "build",
    "windows",
    "--release",
    "--build-name=$($version.BuildName)",
    "--build-number=$($version.BuildNumber)"
  )
  $dartDefineArg = Resolve-DartDefineArgument
  if ($dartDefineArg) {
    $args += $dartDefineArg
  }
  & $flutterSdk @args
  if ($LASTEXITCODE -ne 0) {
    throw "O build Windows falhou antes de gerar o bundle."
  }

  $buildOutput = ".\build\windows\x64\runner\Release"
  if (-not (Test-Path $buildOutput)) {
    throw "Bundle Windows nao encontrado em '$buildOutput'."
  }
  Copy-Item $buildOutput $artifactBase -Recurse -Force
  Compress-Archive -Path "$artifactBase\*" -DestinationPath "$artifactBase.zip" -Force

  Write-Host "Bundle gerado em: $artifactBase"
  Write-Host "Zip gerado em: $artifactBase.zip"
}
finally {
  if (Test-Path ".\env\runtime.generated.json") {
    Remove-Item ".\env\runtime.generated.json" -Force
  }
  Pop-Location
}
