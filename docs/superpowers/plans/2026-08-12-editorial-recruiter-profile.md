# Editorial Recruiter Profile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a concise bilingual GitHub profile that presents Andrin Maag and three verified projects clearly to IMS internship recruiters.

**Architecture:** Keep the profile as GitHub-sanitised Markdown with native named `<details>` language groups and theme-aware `<picture>` assets. Put all content checks in the existing PowerShell verification script, then apply account and repository metadata separately through the authenticated GitHub interface and verify those mutations through the public GitHub API.

**Tech Stack:** GitHub Flavored Markdown, HTML supported by GitHub, local PNG assets, PowerShell 5.1/7, GitHub web UI, GitHub REST API for read-back verification, Chrome DevTools.

---

## File Map

- Modify `README.md`: complete German and English Editorial Recruiter layout.
- Modify `scripts/verify-profile.ps1`: executable requirements for copy, language behaviour, local assets, links, and removed visual clutter.
- Delete `assets/profile-focus.gif`: theme-incompatible animation.
- Delete `assets/tech-stack-dark.svg`: superseded rounded-square technology strip.
- Delete `assets/tech-stack-light.svg`: superseded rounded-square technology strip.
- Delete `assets/TECH-ICON-CREDIT.md`: credit for removed third-party icon strip.
- Delete `assets/profile-header-generated.png`: unused superseded generated header.
- Retain `assets/profile-header-workspace-hq.png`: approved dark-theme header.
- Retain `assets/profile-header-workspace-light.png`: approved light-theme header.
- Retain `assets/PHOTO-CREDIT.md`: source credit for the real workspace photograph.

### Task 1: Lock the Editorial Requirements in Verification

**Files:**
- Modify: `scripts/verify-profile.ps1`
- Test: `scripts/verify-profile.ps1`

- [ ] **Step 1: Replace the old required profile strings**

In `$profileFiles['README.md']`, require these exact strings:

```powershell
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
        '01 · Exam Countdown',
        '02 · Orbit Defender',
        '03 · CO2 Data Analysis',
        'Core',
        'Im Einsatz',
        'Workflow',
        'In daily use'
    )
}
```

Replace `$requiredText` with:

```powershell
$requiredText = @(
    'Andrin Maag',
    'IMS Student Developer',
    'Momik-jpg/TestColdown',
    'Momik-jpg/orbit-defender-monogame',
    'Momik-jpg/LB259',
    '## Ausgewählte Arbeiten',
    '## Selected Work',
    '## Meine Arbeitsweise',
    '## How I Work',
    'Offen für IMS-Praktika',
    'Open to IMS internships'
)
```

- [ ] **Step 2: Forbid superseded visual elements**

Append these patterns to `$forbiddenPatterns`:

```powershell
'profile-focus\.gif',
'tech-stack-(?:dark|light)\.svg',
'TECH-ICON-CREDIT',
'<marquee\b',
'<script\b'
```

Delete the `$technologyIconSources` count check. Replace `$requiredAssets` with:

```powershell
$requiredAssets = @(
    'assets/profile-header-workspace-hq.png',
    'assets/profile-header-workspace-light.png',
    'assets/PHOTO-CREDIT.md'
)
```

- [ ] **Step 3: Add a test for exactly three project links per language**

Insert after the language-group checks:

```powershell
$projectLinks = @(
    'https://github.com/Momik-jpg/TestColdown',
    'https://github.com/Momik-jpg/orbit-defender-monogame',
    'https://github.com/Momik-jpg/LB259'
)
foreach ($projectLink in $projectLinks) {
    $linkCount = ([regex]::Matches($profileText, [regex]::Escape($projectLink))).Count
    if ($linkCount -ne 2) {
        $failures.Add("Expected project link twice, found ${linkCount}: $projectLink")
    }
}
```

- [ ] **Step 4: Run the new verification and confirm that the current README fails**

Run:

```powershell
pwsh -NoProfile -File scripts/verify-profile.ps1
```

Expected: exit code `1` with missing positioning statements and forbidden `profile-focus.gif` / `tech-stack-*.svg` references.

- [ ] **Step 5: Commit the failing verification contract**

```powershell
git add scripts/verify-profile.ps1
git commit -m "test: define editorial profile requirements"
```

### Task 2: Rewrite the Bilingual README

**Files:**
- Modify: `README.md`
- Test: `scripts/verify-profile.ps1`

- [ ] **Step 1: Keep the approved theme-aware header and remove the GIF block**

The README must begin exactly with:

```html
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="assets/profile-header-workspace-hq.png">
  <source media="(prefers-color-scheme: light)" srcset="assets/profile-header-workspace-light.png">
  <img alt="Andrin Maag - IMS Student Developer" src="assets/profile-header-workspace-light.png">
</picture>
```

Do not place any animated image between this block and the language groups.

- [ ] **Step 2: Build the English language section**

Use a closed `<details name="profile-language">` section with summary `<strong>English</strong> · Read in English`. Its content must use this order and copy:

```markdown
## I build software that works in everyday life.

I create clear interfaces, maintainable code, and carefully verified solutions. I am an IMS student from Aargau with a current focus on Android, C#, Kotlin, and practical software development.

| Focus | Approach | Status |
| --- | --- | --- |
| Android and C# | Structured and user-focused | Open to IMS internships in Switzerland |

## Selected Work

### [01 · Exam Countdown](https://github.com/Momik-jpg/TestColdown)

An Android exam planner that brings schedules, reminders, widgets, grade tools, exports, and iCal synchronisation into one focused workflow. The project uses privacy-focused local storage and handles time-based behaviour carefully.

`Kotlin` `Android` `Widgets` `iCal` `Local storage`

### [02 · Orbit Defender](https://github.com/Momik-jpg/orbit-defender-monogame)

A MonoGame arcade project with a structured game loop, service-based responsibilities, collision handling, increasing difficulty, and persistent JSON high scores.

`C#` `.NET 8` `MonoGame` `JSON` `Game architecture`

### [03 · CO2 Data Analysis](https://github.com/Momik-jpg/LB259)

A documented analysis of public CO2 data covering data cleaning, privacy decisions, source attribution, regression visualisation, and model predictions.

`Python` `Jupyter Notebook` `Open data` `Regression`

## Technology

| Core | In daily use | Workflow |
| --- | --- | --- |
| **C# · Kotlin · Android** | .NET · Python · Jupyter | Git · GitHub |

## How I Work

- **Understand:** clarify the problem, constraints, and expected user experience.
- **Structure:** divide larger features into focused responsibilities and verifiable steps.
- **Build:** prefer readable code and platform conventions over unnecessary complexity.
- **Verify:** test behaviour, edge cases, accessibility, and the user experience.
- **Document:** keep decisions and setup understandable for the next person.

## Currently Learning

- Maintainable Android development with Kotlin
- Clear architecture in larger C# and .NET projects
- Automated tests, accessibility, documentation, and release quality

---

<p align="center">
  Open to IMS internships and learning opportunities in Switzerland.<br>
  <a href="https://github.com/Momik-jpg?tab=repositories"><strong>Explore all repositories →</strong></a>
</p>
```

- [ ] **Step 3: Build the German language section**

Use `<details name="profile-language" open>` with summary `<strong>Deutsch</strong> · Auf Deutsch lesen`. Mirror the English structure with this approved German copy:

```markdown
## Ich entwickle Software, die im Alltag funktioniert.

Ich entwickle klare Benutzeroberflächen, wartbaren Code und sorgfältig überprüfte Lösungen. Als IMS-Schüler aus dem Aargau liegt mein aktueller Fokus auf Android, C#, Kotlin und praktischer Softwareentwicklung.

| Fokus | Arbeitsweise | Status |
| --- | --- | --- |
| Android und C# | Strukturiert und benutzerorientiert | Offen für IMS-Praktika in der Schweiz |

## Ausgewählte Arbeiten

### [01 · Exam Countdown](https://github.com/Momik-jpg/TestColdown)

Ein Android-Prüfungsplaner, der Stundenplan, Erinnerungen, Widgets, Notenwerkzeuge, Exporte und iCal-Synchronisation in einem fokussierten Ablauf verbindet. Das Projekt verwendet datenschutzorientierte lokale Speicherung und behandelt zeitabhängiges Verhalten sorgfältig.

`Kotlin` `Android` `Widgets` `iCal` `Lokale Daten`

### [02 · Orbit Defender](https://github.com/Momik-jpg/orbit-defender-monogame)

Ein MonoGame-Arcadeprojekt mit strukturiertem Game Loop, klar getrennten Diensten, Kollisionsbehandlung, steigendem Schwierigkeitsgrad und persistenten JSON-Highscores.

`C#` `.NET 8` `MonoGame` `JSON` `Spielarchitektur`

### [03 · CO2 Data Analysis](https://github.com/Momik-jpg/LB259)

Eine dokumentierte Analyse öffentlicher CO2-Daten mit Datenbereinigung, Datenschutzentscheiden, Quellenangaben, Regressionsvisualisierung und Modellprognosen.

`Python` `Jupyter Notebook` `Open Data` `Regression`

## Technologien

| Core | Im Einsatz | Workflow |
| --- | --- | --- |
| **C# · Kotlin · Android** | .NET · Python · Jupyter | Git · GitHub |

## Meine Arbeitsweise

- **Verstehen:** Problem, Einschränkungen und erwartetes Benutzererlebnis klären.
- **Strukturieren:** grössere Funktionen in klare Zuständigkeiten und überprüfbare Schritte aufteilen.
- **Umsetzen:** lesbaren Code und Plattformkonventionen unnötiger Komplexität vorziehen.
- **Überprüfen:** Verhalten, Randfälle, Barrierefreiheit und Bedienung testen.
- **Dokumentieren:** Entscheidungen und Einrichtung für die nächste Person verständlich halten.

## Aktuell lerne ich

- Wartbare Android-Entwicklung mit Kotlin
- Klare Architektur in grösseren C#- und .NET-Projekten
- Automatisierte Tests, Barrierefreiheit, Dokumentation und Release-Qualität

---

<p align="center">
  Offen für IMS-Praktika und Lernmöglichkeiten in der Schweiz.<br>
  <a href="https://github.com/Momik-jpg?tab=repositories"><strong>Alle Repositories ansehen →</strong></a>
</p>
```

- [ ] **Step 4: Run the verification and confirm that the content contract passes**

Run:

```powershell
pwsh -NoProfile -File scripts/verify-profile.ps1
```

Expected: `Profile README verification passed.`

- [ ] **Step 5: Commit the README redesign**

```powershell
git add README.md
git commit -m "feat: publish editorial recruiter profile"
```

### Task 3: Remove Superseded Assets

**Files:**
- Delete: `assets/profile-focus.gif`
- Delete: `assets/tech-stack-dark.svg`
- Delete: `assets/tech-stack-light.svg`
- Delete: `assets/TECH-ICON-CREDIT.md`
- Delete: `assets/profile-header-generated.png`
- Test: `scripts/verify-profile.ps1`

- [ ] **Step 1: Confirm that none of the files are referenced**

Run:

```powershell
rg -n "profile-focus|tech-stack-|TECH-ICON-CREDIT|profile-header-generated" README.md scripts assets
```

Expected: no matches in `README.md` or `scripts/verify-profile.ps1`; matches may only identify the files being removed.

- [ ] **Step 2: Remove the five superseded assets**

```powershell
git rm assets/profile-focus.gif assets/tech-stack-dark.svg assets/tech-stack-light.svg assets/TECH-ICON-CREDIT.md assets/profile-header-generated.png
```

- [ ] **Step 3: Verify the profile after asset removal**

```powershell
pwsh -NoProfile -File scripts/verify-profile.ps1
git diff --check
```

Expected: profile verification passes and `git diff --check` prints nothing.

- [ ] **Step 4: Commit the asset cleanup**

```powershell
git commit -m "chore: remove superseded profile artwork"
```

### Task 4: Verify GitHub Rendering Before Publishing

**Files:**
- Test: `README.md`
- Test: `scripts/verify-profile.ps1`

- [ ] **Step 1: Run verification in PowerShell 7 and Windows PowerShell 5.1**

```powershell
pwsh -NoProfile -File scripts/verify-profile.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File scripts/verify-profile.ps1
```

Expected from each command: `Profile README verification passed.`

- [ ] **Step 2: Validate repository state**

```powershell
git diff --check
git status --short
git log -5 --oneline
```

Expected: no tracked uncommitted changes; `.superpowers/` may remain untracked and must not be committed.

- [ ] **Step 3: Render through GitHub's Markdown API or a temporary branch view**

Inspect the rendered HTML and confirm:

- two named language groups survive sanitisation,
- German alone is open by default,
- both header sources survive,
- no GIF or technology-strip SVG is present,
- all six project-link occurrences are present.

- [ ] **Step 4: Check the rendered profile at four viewport/theme combinations**

Use Chrome DevTools at:

- desktop `1440 × 1000`, light,
- desktop `1440 × 1000`, dark,
- mobile `390 × 844`, light,
- mobile `390 × 844`, dark.

At each combination verify no horizontal overflow, readable header text, aligned tables, working project links, and mutually exclusive language groups.

### Task 5: Publish the README Redesign

**Files:**
- Publish commits from the profile worktree to `Momik-jpg/Momik-jpg` `main`

- [ ] **Step 1: Fetch and verify that the remote can fast-forward**

```powershell
git fetch origin main
git merge-base --is-ancestor origin/main HEAD
```

Expected: exit code `0`. If it fails, stop and inspect the remote commits; do not force-push.

- [ ] **Step 2: Push the completed profile commits**

```powershell
git push origin HEAD:main
```

Expected: successful fast-forward update of `main`.

- [ ] **Step 3: Reload the live profile**

Open `https://github.com/Momik-jpg?profile-refresh=<new-commit>` and repeat the four viewport/theme checks from Task 4 against the published result.

### Task 6: Update Account and Repository Metadata

**Files:**
- External GitHub profile metadata
- External GitHub repository metadata for `TestColdown`, `orbit-defender-monogame`, and `LB259`

- [ ] **Step 1: Update the account profile through the authenticated GitHub profile editor**

Set only these fields:

```text
Name: Andrin Maag
Bio: IMS student · C# & Kotlin developer · Building practical software
Location: Aargau, Switzerland
```

Leave avatar, username, email, website, company, and social links unchanged.

- [ ] **Step 2: Update Exam Countdown metadata**

For `Momik-jpg/TestColdown`, set:

```text
Description: Android exam planner with schedules, reminders, widgets, grade tools, iCal sync, and privacy-focused local storage.
Topics: android, kotlin, exam-planner, ical, widgets, education
```

- [ ] **Step 3: Update Orbit Defender metadata**

For `Momik-jpg/orbit-defender-monogame`, set:

```text
Description: MonoGame arcade project with a structured C# game loop, service-based architecture, collisions, and persistent JSON high scores.
Topics: csharp, dotnet, monogame, game-development, oop, json
```

- [ ] **Step 4: Update CO2 Data Analysis metadata**

For `Momik-jpg/LB259`, set:

```text
Description: Jupyter analysis of public CO2 data with documented cleaning, privacy decisions, regression, and source attribution.
Topics: data-analysis, jupyter-notebook, open-data, regression, co2-emissions
```

- [ ] **Step 5: Read back all public metadata through the GitHub REST API**

GET these endpoints and compare the exact values:

```text
https://api.github.com/users/Momik-jpg
https://api.github.com/repos/Momik-jpg/TestColdown
https://api.github.com/repos/Momik-jpg/orbit-defender-monogame
https://api.github.com/repos/Momik-jpg/LB259
```

Expected: the account `name`, `bio`, and `location`, plus every repository `description` and `topics` array, match Steps 1-4.

### Task 7: Curate Pinned Repositories and Final Review

**Files:**
- External GitHub pinned-repository selection

- [ ] **Step 1: Open the profile pin customisation dialog**

Select exactly these repositories in this order where GitHub permits ordering:

```text
TestColdown
orbit-defender-monogame
LB259
```

Remove unrelated repositories from the pinned selection.

- [ ] **Step 2: Verify the public profile card content**

Reload `https://github.com/Momik-jpg` and confirm all three pinned cards show the new descriptions and correct primary languages.

- [ ] **Step 3: Perform the final recruiter scan**

Starting at the top of the profile, confirm a first-time visitor can identify within one screen:

- full name `Andrin Maag`,
- IMS student/developer role,
- Android and C# focus,
- availability for IMS internships,
- an immediate path to the three selected projects.

- [ ] **Step 4: Record final state**

Report the published profile commit, the three metadata updates, the pinning result, and the four viewport/theme checks. Explicitly mention any GitHub action that could not be completed or verified.

