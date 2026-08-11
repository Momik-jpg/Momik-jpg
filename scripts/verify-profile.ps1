$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$canonicalRepositoryRoot = [IO.Path]::GetFullPath($repositoryRoot)
$repositoryBoundary = $canonicalRepositoryRoot.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$readmePath = Join-Path $repositoryRoot 'README.md'
$readme = Get-Content -Raw -LiteralPath $readmePath

$requiredText = @(
    'Andrin Maag',
    'IMS Student Developer',
    'Ich entwickle praktische Software',
    'I build practical software',
    'Momik-jpg/TestColdown',
    'Momik-jpg/orbit-defender-monogame',
    'Momik-jpg/LB259',
    'assets/profile-header.svg'
)

$forbiddenPatterns = @(
    '\bTBD\b',
    '\bTODO\b',
    'currently working on \.\.\.',
    'github-readme-stats',
    'visitor badge',
    'commit quest'
)

$failures = [System.Collections.Generic.List[string]]::new()
$fencedBlockPattern = '(?ms)^[ \t]*(?<fence>```|~~~)[^\r\n]*\r?\n.*?^[ \t]*\k<fence>[ \t]*\r?(?=\n|$)'
$profileText = [regex]::Replace($readme, $fencedBlockPattern, '')

foreach ($text in $requiredText) {
    if (-not $profileText.Contains($text)) {
        $failures.Add("Missing required text: $text")
    }
}

foreach ($pattern in $forbiddenPatterns) {
    if ([regex]::IsMatch($profileText, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)) {
        $failures.Add("Forbidden profile content matched: $pattern")
    }
}

function Test-ExternalImageDestination {
    param([string] $Destination)

    return $Destination -match '^(?:[a-z][a-z0-9+.-]*:|//|#)'
}

$inlineImagePattern = '(?<!\\)!\[[^\]\r\n]*\]\(\s*(?<destination><[^>\r\n]*>|[^\s()]*)(?:[ \t]+(?:"[^"\r\n]*"|''[^''\r\n]*''|\([^()\r\n]*\)))?\s*\)'
$inlineImages = [regex]::Matches($profileText, $inlineImagePattern)

foreach ($image in $inlineImages) {
    $destination = $image.Groups['destination'].Value.Trim()
    if ($destination.StartsWith('<') -and $destination.EndsWith('>')) {
        $destination = $destination.Substring(1, $destination.Length - 2).Trim()
    }

    if ([string]::IsNullOrWhiteSpace($destination)) {
        $failures.Add('Empty image destination. Use a local inline Markdown path.')
    }
    elseif ([IO.Path]::IsPathRooted($destination) -and -not $destination.StartsWith('//')) {
        $failures.Add("Unsupported absolute local image path: $destination. Use a repository-relative path.")
    }
    elseif (-not (Test-ExternalImageDestination $destination)) {
        try {
            $assetPath = [IO.Path]::GetFullPath((Join-Path $canonicalRepositoryRoot $destination))
        }
        catch {
            $failures.Add("Invalid local image path: $destination")
            continue
        }

        if (-not $assetPath.StartsWith($repositoryBoundary, [System.StringComparison]::OrdinalIgnoreCase)) {
            $failures.Add("Local image path escapes repository: $destination")
        }
        elseif (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
            $failures.Add("Missing local image: $destination")
        }
    }
}

$htmlImagePattern = '<img\b[^>]*\bsrc\s*=\s*(?:"(?<source>[^"]*)"|''(?<source>[^'']*)''|(?<source>[^\s>]+))[^>]*>'
$htmlImages = [regex]::Matches(
    $profileText,
    $htmlImagePattern,
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
)

foreach ($image in $htmlImages) {
    $source = $image.Groups['source'].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($source)) {
        $failures.Add('Empty image destination. Use a local inline Markdown path.')
    }
    elseif ([IO.Path]::IsPathRooted($source) -and -not $source.StartsWith('//')) {
        $failures.Add("Unsupported absolute local image path: $source. Use a repository-relative path.")
    }
    elseif (-not (Test-ExternalImageDestination $source)) {
        $failures.Add("Unsupported local HTML image: $source. Use inline Markdown instead.")
    }
}

$referenceImagePattern = '(?<!\\)!\[[^\]\r\n]*\]\[[^\]\r\n]*\]|(?<!\\)!\[[^\]\r\n]+\](?!\s*[\(\[])'
if ([regex]::IsMatch($profileText, $referenceImagePattern)) {
    $failures.Add('Unsupported reference-style image. Use inline Markdown instead.')
}

if ($failures.Count -gt 0) {
    $failures | ForEach-Object { [Console]::Error.WriteLine($_) }
    exit 1
}

Write-Output 'Profile README verification passed.'
