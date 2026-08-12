# Interactive Bilingual Profile Design

## Goal

Upgrade Andrin Maag's GitHub profile README with a clearer bilingual experience, richer recruiter-focused content, and restrained visual effects that work reliably in GitHub's light and dark themes.

## Confirmed Direction

The language control will combine the visual clarity of the compared B design with the native behaviour of the A design:

- Two prominent language selectors labelled `Deutsch` and `English`.
- Switching happens inside the profile README.
- No language link opens a separate repository file or another page.
- German is expanded by default.
- Opening one language closes the other through two named HTML `<details>` elements.
- The controls use GitHub-rendered HTML only, without JavaScript or custom CSS.

GitHub does not provide true client-side tabs in README files. The visual treatment therefore suggests tabs while preserving the honest native disclosure interaction.

## Professional Header

The existing generated workspace image will be replaced with the selected real Coding Studio photograph from Pexels. The photograph will be downloaded into the repository so the profile does not depend on a hotlinked image.

- Source: Pexels photo 34804001 by Daniil Komov.
- Composition: the coding workspace remains visible while a restrained dark overlay creates a calm text area on the left.
- Text: `Andrin Maag`, `IMS Student · Software Developer`, and `C# · Kotlin · Android · Python`.
- Typography is rendered locally during asset generation rather than produced by an image model, ensuring sharp and correctly spelled text.
- Separate light and dark variants use the same photograph and information with adjusted contrast.
- The final assets remain within GitHub's recommended image dimensions and are optimised for sharp rendering without excessive file size.

## Content Structure

Each language section will contain the same information hierarchy:

1. Compact in-page navigation.
2. Introduction and current IMS status.
3. Short profile facts covering location, focus, and internship interest.
4. Three selected projects with stronger descriptions of responsibilities, engineering choices, and outcomes.
5. Technology badges for C#, Kotlin, Android, Python, Git, GitHub, .NET, and Jupyter.
6. A compact development workflow section.
7. Current learning goals.
8. A clear closing line for internships and collaboration.

German and English will communicate the same facts rather than introduce conflicting claims. Text will remain concise enough for recruiter scanning.

## Visual Effects

The profile will use only effects that GitHub supports reliably:

- Automatic theme-specific header images through `<picture>` and `prefers-color-scheme`.
- Native expanding and collapsing sections through `<details>`.
- In-page anchor navigation for a website-like reading flow.
- Consistent technology badges with recognisable official symbols.
- One restrained, locally stored animated SVG line below the header. It cycles through a maximum of two short statements and provides a static readable fallback inside the SVG.

The animation will be informative rather than decorative. It will communicate Andrin's focus on practical software and his primary technologies. It must remain legible in both themes and avoid rapid, continuous movement.

Animated contribution snakes, visitor counters, autoplay media, excessive badges, externally hosted typing services, and misleading live statistics are excluded. They would distract from the recruiter-focused presentation or introduce unnecessary third-party reliability risks.

## Light And Dark Themes

- Existing theme-specific header assets remain the visual foundation.
- The selected real photograph replaces the current generated scene in both header variants.
- Technology symbols must have sufficient contrast in both GitHub themes.
- Any dynamic SVG must use a transparent background and readable accent colour, or be removed if it cannot adapt cleanly.
- No text will be embedded in a theme-dependent image unless both image variants contain the same information.

## Interaction Behaviour

- Initial state: German open, English closed.
- Selecting English: English opens and German closes.
- Selecting German: German opens and English closes.
- Section navigation remains on `https://github.com/Momik-jpg` and changes only the URL fragment.
- Project names remain real links to their repositories.
- All controls remain keyboard accessible through GitHub's native rendering.

## Verification

The change is complete only after:

- `scripts/verify-profile.ps1` passes in PowerShell 7 and Windows PowerShell 5.1.
- GitHub's Markdown API renders both named language sections and all internal anchors.
- The live GitHub profile is checked in light and dark modes.
- Language switching is tested without leaving the profile.
- Header images and every technology badge load with non-zero dimensions.
- German and English content are checked for matching facts and valid links.
- `git diff --check` reports no whitespace errors.

## Scope

This iteration changes the profile README, replaces its two header assets, adds one local animated SVG, records the photo attribution, and updates the verification script. It does not create GitHub Pages, add a separate website, rewrite repository histories, or modify the selected projects.
