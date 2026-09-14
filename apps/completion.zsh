if (( $+commands[pass] )); then
  compdef passc='pass'
fi

if (( $+commands[yt-dlp] )); then
  compdef ytdl='yt-dlp'
  compdef ytdl-audio='yt-dlp'
fi
