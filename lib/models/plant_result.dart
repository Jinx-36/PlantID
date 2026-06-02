class PlantResult {
  final String commonName;
  final String scientificName;
  final String family;
  final double confidence;
  final String? imageUrl;

  PlantResult({
    required this.commonName,
    required this.scientificName,
    required this.family,
    required this.confidence,
    this.imageUrl,
  });

  factory PlantResult.fromJson(Map<String, dynamic> json) {
    final species = json['species'];
    return PlantResult(
      commonName: (species['commonNames'] as List).isNotEmpty
          ? species['commonNames'][0]
          : species['scientificNameWithoutAuthor'],
      scientificName: species['scientificNameWithoutAuthor'],
      family: species['family']['scientificNameWithoutAuthor'],
      confidence: (json['score'] as num).toDouble() * 100,
      imageUrl: json['images'] != null && (json['images'] as List).isNotEmpty
          ? json['images'][0]['url']['m']
          : null,
    );
  }
}
