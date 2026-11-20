# AGENTS.md

## Project
Implementations of Swatch Internet Time (`@beats`, Biel Mean Time). A Creabyte classic that has been online since about 1999. Live demo: https://www.creabyte.com/swatchbeat — GitHub Pages: https://noviceiii.github.io/Swatchbeat/

## Stack
Three independent implementations, no framework and no database: static HTML/JS (`web/`), POSIX shell (`shell/`), Perl (`perl/`).

## Structure
- `web/` — standalone HTML clock and converters
- `shell/swatchbeat.sh` — shell CLI
- `perl/swatchbeat.pl` — Perl CLI
- `VERSION` — version SSOT
- `.github/workflows/pages.yml` — deploys `web/` to GitHub Pages

## Commands
- Web (local): `cd web && python3 -m http.server 8080` (then http://localhost:8080), or open `web/index.html`
- Shell: `./shell/swatchbeat.sh`, `./shell/swatchbeat.sh --clock 14:30`, `./shell/swatchbeat.sh --beat 500`
- Perl: `./perl/swatchbeat.pl`, `./perl/swatchbeat.pl --clock 14:30`, `./perl/swatchbeat.pl --beat 500`

## Environments
Not a PHP web app and there is no `deploy.php`. The `web/` tree is published via GitHub Pages; creabyte.com hosts its own copy.

## Conventions
Code, comments and docs in English. All three implementations must keep the same conversion rules. Version is root `VERSION`, tags plain `X.Y.Z`. Branch + PR to `main`.
Follow the shared `coding-standards` skill.

## Do not touch
Release zip artifacts; do not add affiliation claims toward Swatch Group.

## Known pitfalls
The day is measured in BMT (UTC+1, no daylight saving). One beat is 86.4 seconds. Midnight BMT is `@000`.
