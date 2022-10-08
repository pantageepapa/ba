class Artist {
  const Artist({
    required this.artistName,
    required this.artistImageUrl,
  });

  final String? artistImageUrl;
  final String artistName;

  static List<Artist>? fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    List<Artist> artists = [];

    for (int i = 0; i < json['items'].length; i++) {
      final artistName = json['items'][i]['name'] != ''
          ? json['items'][i]['name']
          : "Unknown Artist";

      final artistImageUrl = json['items'][i]['images'].length != 0
          ? json['items'][i]['images'][0]['url']
          : null;
      Artist artist = Artist(
        artistName: artistName,
        artistImageUrl: artistImageUrl,
      );
      artists.add(artist);
    }

    return artists;
  }
}
