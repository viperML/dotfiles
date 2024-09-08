#!/usr/bin/env perl
use v5.38;
use strict;
use warnings;

use Config::INI::Reader;

my $session = $ARGV[0];
if (not defined $session) {
    die "Usage: $0 <session>\n";
}

say "Session: $session";

my @session_dirs = (
    "/run/current-system/sw/share/wayland-sessions",
    "/run/current-system/sw/share/xsessions",
);

foreach my $dir (@session_dirs) {
    opendir(my $dh, $dir) or die "Can't open $dir: $!";

    foreach my $file (readdir $dh) {
        next if $file =~ /^\.\.?$/;
        say $file;

        # Check if $file matches $session.desktop
        if ($file =~ /^$session\.desktop$/) {
            my $path = "$dir/$file";
            say "Found $path";

            my $ini = Config::INI::Reader->read_file($path);
            my $exec = $ini->{"Desktop Entry"}->{Exec};
            say "Exec: $exec";
            exec $exec;
        }
    }
}

