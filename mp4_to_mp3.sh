for f in *;do flac -cd $f |lame -b 128 - $f.mp3;done
