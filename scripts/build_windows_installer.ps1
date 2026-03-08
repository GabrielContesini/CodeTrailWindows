$ErrorActionPreference = "Stop"
$iconGeneratorScript = Join-Path $PSScriptRoot "generate_windows_icon.ps1"
$releaseBuilderScript = Join-Path $PSScriptRoot "build_windows_release.ps1"

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
    FullVersion = "$($Matches.buildName)+$($Matches.buildNumber)"
  }
}

function Find-InnoSetupCompiler {
  $candidates = @(
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "${env:ProgramFiles}\Inno Setup 6\ISCC.exe"
  )

  foreach ($candidate in $candidates) {
    if (Test-Path $candidate) {
      return $candidate
    }
  }

  throw "ISCC.exe nao encontrado. Instale o Inno Setup 6 para gerar o instalador."
}

function Find-LatestReleaseBundle {
  param(
    [string]$FullVersion
  )

  $prefix = "CodeTrailWindows-$FullVersion-release"
  $candidates = Get-ChildItem ".\artifacts\release" -Directory -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -eq $prefix -or $_.Name -like "$prefix-r*" } |
    Sort-Object LastWriteTimeUtc, Name

  if (-not $candidates) {
    throw "Nenhum bundle release encontrado para a versao '$FullVersion'. Rode primeiro .\scripts\build_windows_release.ps1."
  }

  return $candidates[-1]
}

$projectRoot = Split-Path -Parent $PSScriptRoot
Push-Location $projectRoot
try {
  & $releaseBuilderScript
  & $iconGeneratorScript

  $version = Get-AppVersionInfo
  $bundleDir = Find-LatestReleaseBundle -FullVersion $version.FullVersion

  $compiler = Find-InnoSetupCompiler
  $templatePath = ".\installer\CodeTrailWindows.iss"
  $tempIssPath = ".\installer\CodeTrailWindows.generated.iss"

  $template = Get-Content $templatePath -Raw
  $template = $template.Replace("__APP_VERSION__", $version.FullVersion)
  $template = $template.Replace("__APP_SOURCE_DIR__", "..\\artifacts\\release\\$($bundleDir.Name)")

  Set-Content -Path $tempIssPath -Value $template -Encoding ASCII
  & $compiler $tempIssPath

  Write-Host "Instalador gerado em artifacts\\installer"
}
finally {
  Pop-Location
}
