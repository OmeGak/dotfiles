// Spicetify 2.45.1 on Spotify 1.3.3 lacks Spicetify.URI, and CosmosAsync
// fails on https URLs ("Resolver not found!"). This fills in what
// playback-bar-waveform.js needs; Spicetify's own versions win once fixed.
(function shim() {
  if (!window.Spicetify?.CosmosAsync || !Spicetify.Platform?.AuthorizationAPI) return setTimeout(shim, 100);

  Spicetify.URI ??= {
    Type: { TRACK: "track", EPISODE: "episode", ALBUM: "album", ARTIST: "artist", PLAYLIST: "playlist" },
    fromString(uri) {
      const [, type, id] = String(uri).split(":");
      return { type, id };
    },
  };

  const cosmosGet = Spicetify.CosmosAsync.get.bind(Spicetify.CosmosAsync);
  Spicetify.CosmosAsync.get = async (url, ...rest) => {
    try {
      return await cosmosGet(url, ...rest);
    } catch (err) {
      if (!/^https:/.test(url)) throw err;
      const { token } = await Spicetify.Platform.AuthorizationAPI.getState();
      const res = await fetch(url, { headers: { authorization: `Bearer ${token.accessToken}` } });
      if (!res.ok) throw err;
      return res.json();
    }
  };
})();
