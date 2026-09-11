# Swatchbeat — Perl

Pure Perl CLI for Internet Time (`@beats`). No non-core modules.

## Run

```bash
chmod +x swatchbeat.pl   # once
./swatchbeat.pl          # current beat
./swatchbeat.pl --clock 14:30
./swatchbeat.pl --clock 14:30:00
./swatchbeat.pl --beat 500
./swatchbeat.pl --beat @500
./swatchbeat.pl --help
```

Times for `--clock` are **BMT (UTC+1)**. Output beat format: `@000.00`.
