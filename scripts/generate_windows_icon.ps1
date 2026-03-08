$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

function Write-IconFile {
  param(
    [string]$SourcePngPath,
    [string]$OutputIcoPath
  )

  $iconSizes = @(256, 128, 64, 48, 32, 24, 16)
  $sourceImage = [System.Drawing.Image]::FromFile($SourcePngPath)

  try {
    $frames = foreach ($iconSize in $iconSizes) {
      $bitmap = New-Object System.Drawing.Bitmap($iconSize, $iconSize)
      try {
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        try {
          $graphics.Clear([System.Drawing.Color]::Transparent)
          $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
          $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
          $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
          $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
          $graphics.DrawImage($sourceImage, 0, 0, $iconSize, $iconSize)
        }
        finally {
          $graphics.Dispose()
        }

        $pngStream = New-Object System.IO.MemoryStream
        $bitmap.Save($pngStream, [System.Drawing.Imaging.ImageFormat]::Png)

        [PSCustomObject]@{
          Size = $iconSize
          Bytes = $pngStream.ToArray()
        }
      }
      finally {
        $bitmap.Dispose()
      }
    }

    $outputDirectory = Split-Path -Parent $OutputIcoPath
    if (-not (Test-Path $outputDirectory)) {
      New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
    }

    $fileStream = [System.IO.File]::Open($OutputIcoPath, [System.IO.FileMode]::Create)
    try {
      $writer = New-Object System.IO.BinaryWriter($fileStream)
      try {
        $writer.Write([UInt16]0)
        $writer.Write([UInt16]1)
        $writer.Write([UInt16]$frames.Count)

        $imageOffset = 6 + ($frames.Count * 16)
        foreach ($frame in $frames) {
          $dimensionByte = if ($frame.Size -ge 256) { 0 } else { [byte]$frame.Size }

          $writer.Write([byte]$dimensionByte)
          $writer.Write([byte]$dimensionByte)
          $writer.Write([byte]0)
          $writer.Write([byte]0)
          $writer.Write([UInt16]1)
          $writer.Write([UInt16]32)
          $writer.Write([UInt32]$frame.Bytes.Length)
          $writer.Write([UInt32]$imageOffset)

          $imageOffset += $frame.Bytes.Length
        }

        foreach ($frame in $frames) {
          $writer.Write($frame.Bytes)
        }
      }
      finally {
        $writer.Dispose()
      }
    }
    finally {
      $fileStream.Dispose()
    }
  }
  finally {
    $sourceImage.Dispose()
  }
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$repositoryRoot = Split-Path -Parent $projectRoot

$sourceCandidates = @(
  (Join-Path $repositoryRoot "CodeTrailIconPack\alternatives\light\icon-full-dark.png"),
  (Join-Path $repositoryRoot "CodeTrailIconPack\play-store\icon-512.png")
)

$sourcePngPath = $sourceCandidates | Where-Object { Test-Path $_ } | Select-Object -First 1
$outputIcoPath = Join-Path $projectRoot "windows\runner\resources\app_icon.ico"

if ($sourcePngPath) {
  Write-IconFile -SourcePngPath $sourcePngPath -OutputIcoPath $outputIcoPath
  Write-Host "Icone do Windows atualizado em: $outputIcoPath"
  exit 0
}

if (Test-Path $outputIcoPath) {
  Write-Host "CodeTrailIconPack nao encontrado. Usando o app_icon.ico versionado em: $outputIcoPath"
  exit 0
}

throw "Nao foi encontrado um PNG do CodeTrailIconPack e tambem nao existe um app_icon.ico versionado para fallback."
