if (( $+commands[pass] )); then
  alias passc="pass -c"
fi

# The Spotify app's credentials stay in pass: spotdl.config.json is public.
if (( $+commands[spotdl] )); then
  alias spotdl='command spotdl --client-id "$(pass show tokens/spotify/client-id)" --client-secret "$(pass show tokens/spotify/client-secret)"'
fi

if (( $+commands[xkcdpass] )); then
  alias xkcdpass="xkcdpass --interactive --numwords=4 --valid-chars='[a-z]' --max=8 --delimiter='-'"
fi

if (( $+commands[yt-dlp] )); then
  alias ytdl='yt-dlp --config-locations=~/.yt-dlp.conf'
  alias ytdl-audio="ytdl --extract-audio --format=bestaudio --audio-format=mp3 --audio-quality=0 --paths=~/Downloads/ytdl/music/ --output='%(title)s [%(id)s].%(ext)s'"
fi
