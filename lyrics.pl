use MIDI;

foreach $one (@ARGV) {
    my $opus = MIDI::Opus->new({ 'from_file' => $one });
    my @tracks = $opus->tracks;
    my $ppq = $opus->ticks;
    my @all_events = ();
    my $max_time = 0;
    # add all relevant events to @all_events array together with their absolute time values (opposed to delta values in @events)
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
    # iterate events sorted by their time value
    foreach $event (sort {$a->[0] <=> $b->[0]} @all_events) {
        my @E = @$event;
        # increment second-time according to the current tempo
        $seconds += ($E[0]-$tick) / $ppq * $tempo / 1e6;
        $tick = $E[0];
        if ($E[1] eq 'set_tempo') {
            $tempo = $E[2];
        }
        if ($E[1] eq 'lyric') {
            my $lyric = $E[2];
            # newline at the begining of the event ends the previous line
            if ($lyric =~ /^[\r\n]/) { print "\\\n"; $flag = 1; }
            # print newline unless this is the first event
            elsif ($has_lyrics) { print "\n"; }
            
            # preprocess the text
            my $outlyric = $lyric;
            $outlyric =~ s/[\n\r]//;
            $outlyric =~ s/\x{e4}/ä/g;
            $outlyric =~ s/\x{f6}/ö/g;
            
            print "$seconds $outlyric";
            
            # newline at the end of the event ends the current line
            if ($lyric =~ /[\r\n]$/) { print "\\\n"; }
            
            # if there is no space, print a hyphen indicating the continuation of the line
            elsif ($lyric !~ / $/) { print "-"; }
            
            $has_lyrics = 1;
        }
    }
    
    if ($has_lyrics) {
        # print a backspace indicating the end of the last line
        if ($flag) { print "\\"; }
        
        # print a newline ending the last syllable
        print "\n";
        
        # print a pseudoevent idicating the end of the song
        print "$seconds END\\\n";
    }
}
