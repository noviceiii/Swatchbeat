# Swatchbeat

**Internet Time** (`@beats`) was invented by the Swiss watch company **[Swatch](https://www.swatch.com/)**.

One day, a thousand beats, the same number everywhere. The day is measured in Biel Mean Time (BMT = UTC+1, no daylight saving). One beat is 86.4 seconds. Midnight BMT is `@000`.

This project has been running since **1999** (classic Creabyte web script). Version **1.0.1**.

Live demo: [creabyte.com/swatchbeat](https://www.creabyte.com/swatchbeat) · GitHub Pages: [noviceiii.github.io/Swatchbeat](https://noviceiii.github.io/Swatchbeat/)

## Implementations

| Path | What | Download |
|------|------|----------|
| [`web/`](web/) | Standalone HTML clock + converters (neutral UI) | [swatchbeat-web-1.0.1.zip](https://github.com/noviceiii/Swatchbeat/releases/download/1.0.1/swatchbeat-web-1.0.1.zip) |
| [`shell/`](shell/) | POSIX shell CLI | [swatchbeat-shell-1.0.1.zip](https://github.com/noviceiii/Swatchbeat/releases/download/1.0.1/swatchbeat-shell-1.0.1.zip) |
| [`perl/`](perl/) | Perl CLI | [swatchbeat-perl-1.0.1.zip](https://github.com/noviceiii/Swatchbeat/releases/download/1.0.1/swatchbeat-perl-1.0.1.zip) |

All three use the same conversion rules. Packages are on the [1.0.1 release](https://github.com/noviceiii/Swatchbeat/releases/tag/1.0.1).

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

- Invented by **Swatch** — [Swatch Internet Time](https://en.wikipedia.org/wiki/Swatch_Internet_Time).
- Standalone repo for further development of the Creabyte classic (online since ~1999).
- Unofficial open-source implementations; not affiliated with Swatch Group.
