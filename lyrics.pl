use MIDI;

foreach $one (@ARGV) {
    my $opus = MIDI::Opus->new({ 'from_file' => $one });
    my @tracks = $opus->tracks;
    my $ppq = $opus->ticks;
    my @all_events = ();
    my $max_time = 0;
    foreach $track (@tracks) {
        my $time = 0;
        my @events = @{ $track->{'events'} };
        foreach $event (@events) {
            my @E = @$event;
            $time += $E[1];
            if ($E[0] eq 'set_tempo') {
                push(@all_events, [$time, 'set_tempo', $E[2]]);
            }
            elsif ($E[0] eq 'lyric') {
                push(@all_events, [$time, 'lyric', $E[2]]);
            }
        }
        if ($time > $max_time) {
            $max_time = $time;
        }
    }
    my $flag = 0;
    my $has_lyrics = 0;
    my $tempo = 500000;
    my $seconds = 0;
    my $tick = 0;
    foreach $event (sort {$a->[0] <=> $b->[0]} @all_events) {
        my @E = @$event;
        $seconds += ($E[0]-$tick) / $ppq * $tempo / 1e6;
        $tick = $E[0];
        if ($E[1] eq 'set_tempo') {
            $tempo = $E[2];
        }
        if ($E[1] eq 'lyric') {
            my $lyric = $E[2];
            if ($lyric =~ /^[\r\n]/) { print "\\\n"; $flag = 1; }
            elsif ($has_lyrics) { print "\n"; }
            my $outlyric = $lyric;
            $outlyric =~ s/[\n\r]//;
            $outlyric =~ s/\x{e4}/ä/g;
            $outlyric =~ s/\x{f6}/ö/g;
            print "$seconds $outlyric";
            if ($lyric =~ /[\r\n]$/) { print "\\\n"; }
            elsif ($lyric !~ / $/) { print "-"; }
            $has_lyrics = 1;
        }
    }
    if ($has_lyrics) {
        if ($flag) { print "\\"; }
        print "\n";
        print "$seconds END\\\n";
    }
}
