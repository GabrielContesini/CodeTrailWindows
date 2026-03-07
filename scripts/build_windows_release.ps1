$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
$flutterSdk = Join-Path (Split-Path -Parent $projectRoot) "flutter\bin\flutter.bat"
$envFile = Join-Path $projectRoot "env\supabase.local.json"

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

Push-Location $projectRoot
try {
  Assert-WindowsDesktopToolchain

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
  if (Test-Path $envFile) {
    $args += "--dart-define-from-file=$envFile"
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
  Pop-Location
}
