#!/usr/bin/env perl
use strict;
use warnings;
use Time::Local qw(timegm);

# Swatchbeat — Internet Time (@beats)
# BMT = UTC+1, no DST. 1 beat = 86.4 seconds.

sub usage {
    print <<'USAGE';
Swatchbeat — Internet Time (@beats)

Usage:
  swatchbeat.pl                 Print current beat
  swatchbeat.pl --clock HH:MM[:SS]
                                Convert BMT (UTC+1) clock to beat
  swatchbeat.pl --beat N        Convert beat (0–999) to BMT clock
  swatchbeat.pl -h | --help     Show this help

Examples:
  swatchbeat.pl --clock 14:30
  swatchbeat.pl --beat 500
  swatchbeat.pl --beat @500
USAGE
}

sub format_beat {
    my ($n) = @_;
    my $v = int($n * 100) / 100;
    my $s = sprintf('%.2f', $v);
    $s = '0' . $s while length($s) < 6;
    return '@' . $s;
}

sub normalize_beat {
    my ($b) = @_;
    $b = $b - int($b / 1000) * 1000;
    $b += 1000 if $b < 0;
    return $b;
}

sub clock_to_beat {
    my ($h, $m, $s) = @_;
    return normalize_beat(($h * 3600 + $m * 60 + $s) / 86.4);
}

sub beat_to_clock {
    my ($b) = @_;
    $b = normalize_beat($b);
    my $total = $b * 86.4;
    my $h = int($total / 3600) % 24;
    my $m = int(($total % 3600) / 60);
    my $s = int($total % 60);
    return sprintf('%02d:%02d:%02d BMT (UTC+1)', $h, $m, $s);
}

sub parse_clock {
    my ($str) = @_;
    return unless defined $str && $str =~ /^(\d{1,2}):(\d{2})(?::(\d{2}))?$/;
    my ($h, $m, $s) = ($1 + 0, $2 + 0, defined $3 ? $3 + 0 : 0);
    return if $h > 23 || $m > 59 || $s > 59;
    return ($h, $m, $s);
}

sub current_beat {
    my @utc = gmtime(time);
    # BMT = UTC+1
    my $sec = (($utc[2] + 1) % 24) * 3600 + $utc[1] * 60 + $utc[0];
    return normalize_beat($sec / 86.4);
}

my $argc = @ARGV;
if ($argc == 0) {
    print format_beat(current_beat()), "\n";
    exit 0;
}

my $cmd = $ARGV[0];
if ($cmd eq '-h' || $cmd eq '--help') {
    usage();
    exit 0;
}

if ($cmd eq '--clock') {
    die "error: --clock needs HH:MM[:SS]\n" unless defined $ARGV[1];
    my @parts = parse_clock($ARGV[1]);
    die "error: use HH:MM or HH:MM:SS (BMT / UTC+1)\n" unless @parts;
    print format_beat(clock_to_beat(@parts)), "\n";
    exit 0;
}

if ($cmd eq '--beat') {
    die "error: --beat needs a number\n" unless defined $ARGV[1];
    my $raw = $ARGV[1];
    $raw =~ s/^@//;
    die "error: enter a beat 0–999\n" unless $raw =~ /^-?\d+(?:\.\d+)?$/;
    print beat_to_clock($raw + 0), "\n";
    exit 0;
}

die "error: unknown option: $cmd\n";
