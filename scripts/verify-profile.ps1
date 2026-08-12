$ErrorActionPreference = 'Stop'

$utf8Encoding = New-Object System.Text.UTF8Encoding($false)
[Console]::OutputEncoding = $utf8Encoding
$middleDot = [char]0x00B7
$aUmlaut = [char]0x00E4
$uUmlaut = [char]0x00FC

function Read-Utf8File {
    param([string] $Path)

    return [IO.File]::ReadAllText($Path, $utf8Encoding)
}

$fencedBlockPattern = '(?ms)^[ \t]*(?<fence>```|~~~)[^\r\n]*\r?\n.*?^[ \t]*\k<fence>[ \t]*\r?(?=\n|$)'
$htmlCommentPattern = '<!--.*?(?:-->|$)'

function Remove-HiddenProfileContent {
    param([string] $Text)

    $unfencedText = [regex]::Replace($Text, $fencedBlockPattern, '')
    return [regex]::Replace(
        $unfencedText,
        $htmlCommentPattern,
        '',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
            [System.Text.RegularExpressions.RegexOptions]::Singleline
    )
}

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$canonicalRepositoryRoot = [IO.Path]::GetFullPath($repositoryRoot)
$repositoryBoundary = $canonicalRepositoryRoot.TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
$profileFiles = @{
    'README.md' = @(
        'Ich entwickle Software, die im Alltag funktioniert.',
        'I build software that works in everyday life.',
        'name="profile-language"',
        '(prefers-color-scheme: dark)',
        '(prefers-color-scheme: light)',
        'assets/profile-header-workspace-hq.png',
        'assets/profile-header-workspace-light.png',
        '<strong>Deutsch</strong>',
        '<strong>English</strong>',
        "01 $middleDot Exam Countdown",
        "02 $middleDot Orbit Defender",
        "03 $middleDot CO2 Data Analysis",
        'Core',
        'Im Einsatz',
        'Workflow',
        'In daily use'
    )
}

$visibleProfileFiles = @{}
foreach ($profileFile in $profileFiles.Keys) {
    $profileFilePath = Join-Path $repositoryRoot $profileFile
    $visibleProfileFiles[$profileFile] = Remove-HiddenProfileContent (Read-Utf8File $profileFilePath)
}
$profileText = ($visibleProfileFiles.Values) -join "`n"

$requiredText = @(
    'Andrin Maag',
    'IMS Student Developer',
    'Momik-jpg/TestColdown',
    'Momik-jpg/orbit-defender-monogame',
    'Momik-jpg/LB259',
    "## Ausgew${aUmlaut}hlte Arbeiten",
    '## Selected Work',
    '## Meine Arbeitsweise',
    '## How I Work',
    "Offen f${uUmlaut}r IMS-Praktika",
    'Open to IMS internships'
)

$forbiddenPatterns = @(
    '\bTBD\b',
    '\bTODO\b',
    'currently working on \.\.\.',
    'github-readme-stats',
    'visitor badge',
    'commit quest',
    'readme-typing-svg',
    'github-profile-views',
    'github-snake',
    'img\.shields\.io',
    'profile-focus\.gif',
    'tech-stack-(?:dark|light)\.svg',
    'TECH-ICON-CREDIT',
    '<marquee\b',
    '<script\b'
)

$failures = [System.Collections.Generic.List[string]]::new()

foreach ($entry in $profileFiles.GetEnumerator()) {
    $fileText = $visibleProfileFiles[$entry.Key]
    foreach ($text in $entry.Value) {
        if (-not $fileText.Contains($text)) {
            $failures.Add("Missing required text in $($entry.Key): $text")
        }
    }
}

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

$languageGroups = [regex]::Matches($profileText, '<details\s+name="profile-language"(?:\s+open)?>', 'IgnoreCase')
if ($languageGroups.Count -ne 2) {
    $failures.Add("Expected exactly two named language groups, found $($languageGroups.Count).")
}

$openLanguageGroups = [regex]::Matches($profileText, '<details\s+name="profile-language"\s+open>', 'IgnoreCase')
if ($openLanguageGroups.Count -ne 1) {
    $failures.Add("Expected exactly one language group open by default, found $($openLanguageGroups.Count).")
}

if (-not [regex]::IsMatch($profileText, '<details\s+name="profile-language"\s+open>\s*<summary><strong>Deutsch</strong>', 'IgnoreCase')) {
    $failures.Add('The German language group must be open by default.')
}

$projectUrls = @(
    'https://github.com/Momik-jpg/TestColdown',
    'https://github.com/Momik-jpg/orbit-defender-monogame',
    'https://github.com/Momik-jpg/LB259'
)
$languageSectionPattern = '<details\s+name="profile-language"(?:\s+open)?>(?<content>.*?)</details\s*>'
$languageSections = [regex]::Matches(
    $profileText,
    $languageSectionPattern,
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase -bor
        [System.Text.RegularExpressions.RegexOptions]::Singleline
)
if ($languageSections.Count -ne 2) {
    $failures.Add("Expected exactly two complete named language sections, found $($languageSections.Count).")
}

foreach ($projectUrl in $projectUrls) {
    $totalProjectLinkCount = ([regex]::Matches($profileText, [regex]::Escape($projectUrl))).Count
    if ($totalProjectLinkCount -ne 2) {
        $failures.Add("Expected project URL exactly twice overall, found $totalProjectLinkCount references: $projectUrl")
    }
}

for ($sectionIndex = 0; $sectionIndex -lt $languageSections.Count; $sectionIndex++) {
    $languageSection = $languageSections[$sectionIndex].Value
    $languageNameMatch = [regex]::Match(
        $languageSection,
        '<summary>\s*<strong>(?<name>[^<]+)</strong>',
        [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
    )
    if ($languageNameMatch.Success) {
        $languageName = $languageNameMatch.Groups['name'].Value
    }
    else {
        $languageName = "language section $($sectionIndex + 1)"
    }

    foreach ($projectUrl in $projectUrls) {
        $projectLinkCount = ([regex]::Matches($languageSection, [regex]::Escape($projectUrl))).Count
        if ($projectLinkCount -ne 1) {
            $failures.Add("Expected project URL exactly once in $languageName, found $projectLinkCount references: $projectUrl")
        }
    }
}

$requiredAssets = @(
    'assets/profile-header-workspace-hq.png',
    'assets/profile-header-workspace-light.png',
    'assets/PHOTO-CREDIT.md'
)
foreach ($asset in $requiredAssets) {
    $assetPath = Join-Path $repositoryRoot $asset
    if (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
        $failures.Add("Missing required profile asset: $asset")
    }
    elseif ((Get-Item -LiteralPath $assetPath).Length -eq 0) {
        $failures.Add("Profile asset is empty: $asset")
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
        try {
            $assetPath = [IO.Path]::GetFullPath((Join-Path $canonicalRepositoryRoot $source))
        }
        catch {
            $failures.Add("Invalid local HTML image path: $source")
            continue
        }

        if (-not $assetPath.StartsWith($repositoryBoundary, [System.StringComparison]::OrdinalIgnoreCase)) {
            $failures.Add("Local HTML image path escapes repository: $source")
        }
        elseif (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
            $failures.Add("Missing local HTML image: $source")
        }
    }
}

$htmlSourcePattern = '<source\b[^>]*\bsrcset\s*=\s*(?:"(?<source>[^"]*)"|''(?<source>[^'']*)''|(?<source>[^\s>]+))[^>]*>'
$htmlSources = [regex]::Matches(
    $profileText,
    $htmlSourcePattern,
    [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
)

foreach ($imageSource in $htmlSources) {
    $source = $imageSource.Groups['source'].Value.Trim()
    if ([string]::IsNullOrWhiteSpace($source)) {
        $failures.Add('Empty picture source destination.')
    }
    elseif ([IO.Path]::IsPathRooted($source) -and -not $source.StartsWith('//')) {
        $failures.Add("Unsupported absolute picture source path: $source")
    }
    elseif (-not (Test-ExternalImageDestination $source)) {
        try {
            $assetPath = [IO.Path]::GetFullPath((Join-Path $canonicalRepositoryRoot $source))
        }
        catch {
            $failures.Add("Invalid local picture source path: $source")
            continue
        }

        if (-not $assetPath.StartsWith($repositoryBoundary, [System.StringComparison]::OrdinalIgnoreCase)) {
            $failures.Add("Local picture source path escapes repository: $source")
        }
        elseif (-not (Test-Path -LiteralPath $assetPath -PathType Leaf)) {
            $failures.Add("Missing local picture source: $source")
        }
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
