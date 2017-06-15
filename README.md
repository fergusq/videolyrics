Videolyrics
###########

The scripts in this repository can be used to create a lyrics video.

## Dependencies

* Bourne Shell (eg. bash)
* Perl 5
	* MIDI::Opus (from CPAN)
* Röda >=0.13
	* fileutil (from Bilar)
* ffmpeg

To install (use root if needed):

	cpan MIDI::Opus
	bilar get fileutil
	dnf install ffmpeg

## How to use

To create a video, you must have the music file and a MIDI file contaning lyric events.

	./makelyrics.sh midi-file music-file output.mp4
