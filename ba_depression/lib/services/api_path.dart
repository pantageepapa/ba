class APIPath {
  static final List<String> _scopes = [
    'user-read-playback-position',
    'user-read-private',
    'user-modify-playback-state',
    'user-read-playback-state',
    'user-read-currently-playing'
  ];

  static String requestAuthorization(
          String clientId, String redirectUri, String state) =>
      'https://accounts.spotify.com/authorize?client_id=$clientId&response_type=code&redirect_uri=$redirectUri&state=$state&scope=${_scopes.join('%20')}';

  static String requestToken = 'https://accounts.spotify.com/api/token';
  static String getCurrentUser = 'https://api.spotify.com/v1/me';
  static String getCurrentTrack = 'https://api.spotify.com/v1/me/player';
  static String pausePlayback = 'https://api.spotify.com/v1/me/player/pause';
  static String playPlayback = 'https://api.spotify.com/v1/me/player/play';
}
