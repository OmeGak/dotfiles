if (( $+commands[xkcdpass] )); then
  alias xkcdpass="xkcdpass --interactive --numwords=4 --valid-chars='[a-z]' --max=8 --delimiter='-'"
fi

if (( $+commands[yt-dlp] )); then
  alias ytdl='yt-dlp --config-locations=~/.yt-dlp.conf'
  alias ytdl-audio="ytdl --extract-audio --format=bestaudio --audio-format=mp3 --audio-quality=0 --paths=~/Downloads/ytdl/music/ --output='%(title)s [%(id)s].%(ext)s'"
fi
