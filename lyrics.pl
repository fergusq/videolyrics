use MIDI;

foreach $one (@ARGV) {
    my $opus = MIDI::Opus->new({ 'from_file' => $one });
    my @tracks = $opus->tracks;
    my $ppq = $opus->ticks;
    my $tempo = 500000;
    foreach $track (@tracks) {
	my $time = 0;
	my @events = @{ $track->{'events'} };
	foreach $event (@events) {
	    my @E = @$event;
	    $time += $E[1];
	    $tempo = $E[2] if ($E[0] eq 'set_tempo');
	    if ($E[0] eq 'lyric') {
		my $seconds = $time / $ppq * $tempo / 1e6;
		print "$seconds $E[2]\n";
	    }
	}
    }
}
