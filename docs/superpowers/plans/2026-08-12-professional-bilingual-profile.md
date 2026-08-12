# Professional Bilingual Profile Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish a professional bilingual GitHub profile with a real photographic header, restrained local motion, richer recruiter-focused content, and a language switch that never leaves the profile.

**Architecture:** GitHub renders a single `README.md` using supported Markdown and sanitised HTML. Two named `<details>` elements provide mutually exclusive language sections, `<picture>` selects theme-specific local images, and a repository-owned animated asset adds subtle motion without a hosted runtime service.

**Tech Stack:** GitHub Flavored Markdown, HTML `<details>` and `<picture>`, Pillow image processing, SVG/GIF animation, PowerShell verification, Playwright/Chrome DevTools live testing.

---

### Task 1: Generate Professional Visual Assets

**Files:**
- Modify: `assets/profile-header-workspace-light.png`
- Modify: `assets/profile-header-workspace-hq.png`
- Create: `assets/profile-focus.gif`
- Create: `assets/PHOTO-CREDIT.md`

- [ ] Download Pexels photo 34804001 at sufficient resolution and store the source only as temporary build input.
- [ ] Crop the photograph to a 4:1 header, apply a left-side contrast overlay, and render `Andrin Maag`, the IMS role, and core technologies with local fonts.
- [ ] Export matched light and dark 2400x600 PNG variants with readable text and controlled file sizes.
- [ ] Generate a small local animation that alternates between `Building clear, practical software.` and `C# · Kotlin · Android · Python` with a static first frame.
- [ ] Record the photographer, source URL, and Pexels origin in `assets/PHOTO-CREDIT.md`.
- [ ] Inspect every generated asset visually and verify dimensions mechanically.

### Task 2: Expand The Bilingual README

**Files:**
- Modify: `README.md`

- [ ] Keep the theme-aware header at the top and insert the local motion asset immediately below it.
- [ ] Restyle the two native language summaries as clear full-width language choices using only GitHub-supported markup.
- [ ] Preserve German-open and English-closed initial state with identical `name="profile-language"` values.
- [ ] Add a compact profile summary, stronger project case-study descriptions, eight technology badges, working approach, current learning goals, and internship contact copy to both languages.
- [ ] Keep internal navigation on the profile and match every factual claim between German and English.

### Task 3: Strengthen Automated Verification

**Files:**
- Modify: `scripts/verify-profile.ps1`

- [ ] Add assertions for exactly two named language groups, German default state, eight badges per language, local animation, local header assets, photo credit, and required section anchors.
- [ ] Run `pwsh -NoProfile -File .\scripts\verify-profile.ps1` and require exit code 0.
- [ ] Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-profile.ps1` and require exit code 0.
- [ ] Run `git diff --check` and inspect the complete staged diff.

### Task 4: Publish And Verify GitHub Rendering

**Files:**
- Modify only files listed in Tasks 1-3.

- [ ] Render `README.md` through GitHub's Markdown API and verify named details, theme picture, animation image, anchors, and badges survive sanitisation.
- [ ] Commit the implementation as one focused profile feature commit.
- [ ] Push the verified commit to the profile repository's published `main` branch.
- [ ] Reload `https://github.com/Momik-jpg` without cache and verify German/English switching does not navigate away.
- [ ] Test light and dark modes, image dimensions, badge loading, anchor navigation, and mobile-width wrapping.
