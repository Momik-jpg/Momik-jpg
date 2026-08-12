# Editorial Recruiter Profile Design

## Objective

Turn the public `Momik-jpg` GitHub profile into a concise bilingual portfolio for IMS internship and apprenticeship recruiters. The profile should feel individually designed, remain credible, and make Andrin's strongest work understandable within a short scan.

## Design Direction

Use the approved **Editorial Recruiter** direction: professional, restrained, and typographically led. The design should rely on clear hierarchy, spacing, concise copy, and real project evidence instead of large technology tiles, decorative badges, statistics cards, or continuous animation.

The visual system uses GitHub's native layout as its foundation. Blue remains the only strong accent. The profile must look intentional in both GitHub light and dark themes.

## Public Profile Metadata

Update the public-facing account metadata where GitHub permits it:

- Display name: `Andrin Maag`
- Bio: `IMS student · C# & Kotlin developer · Building practical software`
- Location: retain `Aargau, Switzerland`

Repository presentation should prioritise three projects:

1. `TestColdown`, presented publicly as **Exam Countdown**
2. `orbit-defender-monogame`, presented as **Orbit Defender**
3. `LB259`, presented as **CO2 Data Analysis**

Each repository should receive a concise factual description and relevant topics based only on functionality already present in the repository. The implementation must not invent adoption, performance, test coverage, production usage, or other unverified claims. Pinning should be updated where GitHub's available tooling permits it; otherwise the required manual pinning steps must be reported clearly.

## README Structure

### 1. Header

Retain the approved real workspace photograph and its existing credit. Keep separate light- and dark-theme image sources through `<picture>`. The header remains the first visual signal and contains Andrin's name, role, and core focus.

Remove the animated focus GIF below the header. Its fixed dark background conflicts with GitHub light mode and adds movement without improving recruiter comprehension.

### 2. Language Control

Keep the native mutually exclusive `<details name="profile-language">` implementation. German is open by default, and English is closed by default. Opening one language closes the other without navigating away from the profile.

The summary labels should be concise and visually balanced. No JavaScript, custom CSS, form controls, or navigation to language-specific repositories may be used because GitHub sanitises unsupported markup.

### 3. Positioning Statement

Open each language section with a short recruiter-facing statement:

- German: `Ich entwickle Software, die im Alltag funktioniert.`
- English: `I build software that works in everyday life.`

Follow it with one short sentence about clear interfaces, maintainable code, and careful verification. Avoid repeating the same information in multiple introductory paragraphs.

### 4. Profile Snapshot

Present three compact facts before the projects:

- Focus: Android and C#
- Approach: structured and user-focused
- Status: open to IMS internships and learning opportunities in Switzerland

Use a GitHub-safe table or a theme-aware local SVG only if it remains readable on mobile. The facts must remain text-accessible and must not depend solely on an image.

### 5. Selected Work

Present the three selected projects as numbered editorial rows. Each row communicates:

- the real problem or use case,
- the main technical contribution,
- a concise technology set,
- a direct link to the repository.

Descriptions should be shorter than the current project paragraphs while preserving concrete details. The rows must scan cleanly on narrow screens and avoid decorative card nesting.

### 6. Technology

Replace the current rounded-square icon strip with quiet competence groups. The preferred structure is:

- Core: C#, Kotlin, Android
- Working with: .NET, Python, Jupyter
- Workflow: Git, GitHub

Use text-first labels with a restrained blue accent. If local SVGs are used, provide separate light and dark variants, meaningful alternative text, and a textual fallback. Large third-party logo tiles are removed.

### 7. Working Style and Learning

Keep a shortened working-style section focused on understanding, structuring, building, verifying, and documenting. Reduce the learning section to the most relevant current goals and avoid generic claims.

End with one centred call to action linking to the repository overview and stating availability for IMS internships in Switzerland. Do not add visitor counters, contribution statistics cards, auto-updating widgets, or external badge services.

## Repository Descriptions and Topics

Inspect each selected repository before changing its metadata. Descriptions should follow this pattern:

`What it is + its clearest differentiating capability`

Topics should be specific technologies or domains already demonstrated by the repository. Avoid broad promotional terms. Repository names must not be renamed unless separately approved because renaming can affect existing links and integrations.

## Accessibility and Compatibility

- Maintain readable contrast in GitHub light and dark themes.
- Provide alternative text for every meaningful image.
- Keep all essential information available as text.
- Respect mobile width; no element may cause horizontal overflow.
- Avoid rapidly moving or continuously distracting animation.
- Use only markup that survives GitHub's Markdown sanitisation.
- Preserve direct, descriptive link text in both languages.

## Verification

Before publishing:

1. Run the local profile verification script and extend it for removed animation references, the new technology presentation, both languages, and required project links.
2. Render the README through GitHub's Markdown pipeline or inspect the live profile after publishing.
3. Check desktop and mobile widths in both light and dark modes.
4. Test opening German and English and confirm that only one remains open.
5. Verify every local asset, external project link, and repository description.
6. Confirm that no unverified claims or unrelated repository changes were introduced.

## Publishing Boundaries

README and asset changes belong to the `Momik-jpg` profile repository. Public account metadata and repository descriptions are separate GitHub mutations and should be applied only to the explicitly approved fields listed above. Existing source code, commit history, releases, and repository names remain unchanged.

