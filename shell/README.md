# Swatchbeat — Shell

POSIX `sh` CLI for Internet Time (`@beats`).

## Run

```bash
chmod +x swatchbeat.sh   # once
./swatchbeat.sh          # current beat
./swatchbeat.sh --clock 14:30
./swatchbeat.sh --clock 14:30:00
./swatchbeat.sh --beat 500
./swatchbeat.sh --beat @500
./swatchbeat.sh --help
```

Times for `--clock` are **BMT (UTC+1)**. Output beat format: `@000.00`.
