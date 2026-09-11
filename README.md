# Swatchbeat

**Internet Time** in `@beats` — one day, a thousand beats, the same number everywhere.

The day is measured in Biel Mean Time (BMT = UTC+1, no daylight saving). One beat is 86.4 seconds. Midnight BMT is `@000`.

Live demo (Creabyte classic): [creabyte.com/swatchbeat](https://www.creabyte.com/swatchbeat)

## Implementations

| Path | What |
|------|------|
| [`web/`](web/) | Standalone HTML clock + converters (neutral UI) |
| [`shell/`](shell/) | POSIX shell CLI |
| [`perl/`](perl/) | Perl CLI |

All three use the same conversion rules.

## Quick start

**Web** — open `web/index.html` in a browser, or:

```bash
cd web && python3 -m http.server 8080
# then visit http://localhost:8080
```

**Shell**

```bash
./shell/swatchbeat.sh
./shell/swatchbeat.sh --clock 14:30
./shell/swatchbeat.sh --beat 500
```

**Perl**

```bash
./perl/swatchbeat.pl
./perl/swatchbeat.pl --clock 14:30
./perl/swatchbeat.pl --beat 500
```

## Notes

- Based on [Swatch Internet Time](https://en.wikipedia.org/wiki/Swatch_Internet_Time).
- This repo is a standalone fork of the Creabyte web script for further development.
