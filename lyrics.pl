use MIDI;

foreach $one (@ARGV) {
    my $opus = MIDI::Opus->new({ 'from_file' => $one });
    my @tracks = $opus->tracks;
    my $ppq = $opus->ticks;
    my $tempo = 500000;
    my $flag = 0;
    foreach $track (@tracks) {
        my $time = 0;
        my @events = @{ $track->{'events'} };
        my $has_lyrics = 0;
        foreach $event (@events) {
            my @E = @$event;
            $time += $E[1];
            $tempo = $E[2] if ($E[0] eq 'set_tempo');
            if ($E[0] eq 'lyric') {
                $has_lyrics = 1;
                my $seconds = $time / $ppq * $tempo / 1e6;
                my $lyric = $E[2];
                if ($lyric =~ /^[\r\n]/) { print "\\\n"; $flag = 1; }
                elsif ($time > $E[1]) { print "\n"; }
                my $outlyric = $lyric;
                $outlyric =~ s/[\n\r]//;
                $outlyric =~ s/\x{e4}/ä/g;
                $outlyric =~ s/\x{f6}/ö/g;
                print "$seconds $outlyric";
                if ($lyric =~ /[\r\n]$/) { print "\\\n"; }
                elsif ($lyric !~ / $/) { print "-"; }
            }
        }
        if ($has_lyrics) {
            if ($flag) { print "\\"; }
            print "\n";
            my $seconds = $time / $ppq * $tempo / 1e6;
            print "$seconds END\\\n";
        }
    }
}
