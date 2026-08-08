[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$HomeVideo,

    [Parameter(Mandatory = $true)]
    [string]$RecommendationsVideo,

    [Parameter(Mandatory = $true)]
    [string]$SearchDetailVideo,

    [Parameter(Mandatory = $true)]
    [string]$ReaderVideo,

    [string]$OutputDirectory = (Join-Path $PSScriptRoot 'generated'),

    [string]$FfmpegPath,

    [switch]$CreatePreviews
)

$ErrorActionPreference = 'Stop'

$sources = @{
    Home = $HomeVideo
    Recommendations = $RecommendationsVideo
    SearchDetail = $SearchDetailVideo
    Reader = $ReaderVideo
}

foreach ($source in $sources.GetEnumerator()) {
    if (-not (Test-Path -LiteralPath $source.Value -PathType Leaf)) {
        throw "Source video '$($source.Key)' was not found: $($source.Value)"
    }
}

if ($FfmpegPath) {
    if (-not (Test-Path -LiteralPath $FfmpegPath -PathType Leaf)) {
        throw "FFmpeg was not found: $FfmpegPath"
    }
    $ffmpegExecutable = (Resolve-Path -LiteralPath $FfmpegPath).Path
} else {
    $ffmpeg = Get-Command ffmpeg -ErrorAction SilentlyContinue
    if (-not $ffmpeg) {
        throw 'FFmpeg is required. Add it to PATH or provide -FfmpegPath.'
    }
    $ffmpegExecutable = $ffmpeg.Source
}

New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null

$clips = @(
    @{ Name = 'home-overview'; Source = $HomeVideo; Start = '00:00:00'; Duration = '00:00:45' },
    @{ Name = 'recommendations-history'; Source = $RecommendationsVideo; Start = '00:00:00'; Duration = '00:00:42.5' },
    @{ Name = 'search-series-detail'; Source = $SearchDetailVideo; Start = '00:00:00'; Duration = '00:00:55' },
    @{ Name = 'library-chapter-selection'; Source = $SearchDetailVideo; Start = '00:01:10'; Duration = '00:00:45' },
    @{ Name = 'reader-experience'; Source = $ReaderVideo; Start = '00:00:15'; Duration = '00:01:00' }
)

foreach ($clip in $clips) {
    $videoOutput = Join-Path $OutputDirectory "$($clip.Name).mp4"
    & $ffmpegExecutable -hide_banner -loglevel error -y `
        -ss $clip.Start -i $clip.Source -t $clip.Duration `
        -an -vf 'scale=720:-2:flags=lanczos' `
        -c:v libx264 -preset slow -crf 24 -movflags +faststart `
        $videoOutput

    if ($LASTEXITCODE -ne 0) {
        throw "FFmpeg failed while creating $($clip.Name)."
    }

    if ($CreatePreviews) {
        $previewOutput = Join-Path $OutputDirectory "$($clip.Name)-preview.webp"
        & $ffmpegExecutable -hide_banner -loglevel error -y `
            -ss $clip.Start -i $clip.Source -t 6 `
            -vf 'fps=8,scale=360:-2:flags=lanczos' -an `
            -loop 0 -quality 65 -compression_level 6 `
            $previewOutput

        if ($LASTEXITCODE -ne 0) {
            throw "FFmpeg failed while creating the $($clip.Name) preview."
        }
    }
}

Write-Host "Generated demo files in: $OutputDirectory"
Write-Warning 'Review every frame for privacy, proprietary information, and publication rights before removing media from .gitignore.'
