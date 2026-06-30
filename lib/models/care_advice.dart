class CareAdvice {
  final String name;
  final String description;
  final String watering;
  final String sunlight;
  final String soil;

  CareAdvice({
    required this.name,
    required this.description,
    required this.watering,
    required this.sunlight,
    required this.soil,
  });

  factory CareAdvice.fromJson(Map<String, dynamic> json) {
    // Check if it's from our new format (Gemini or Cache)
    if (json.containsKey('watering')) {
      return CareAdvice(
        name: json['name'] ?? 'Unknown',
        description: json['description'] ?? 'No description available.',
        watering: json['watering'] ?? 'Not specified',
        sunlight: json['sunlight'] ?? 'Not specified',
        soil: json['soil'] ?? 'Not specified',
      );
    }

    // Fallback for legacy OpenFarm format if still in DB
    final attributes = json['attributes'] ?? json;
    return CareAdvice(
      name: attributes['name'] ?? 'Unknown',
      description: attributes['description'] ?? 'No description available.',
      watering: attributes['sowing_method'] ?? attributes['watering'] ?? 'Not specified',
      sunlight: attributes['sun_requirements'] ?? attributes['sunlight'] ?? 'Not specified',
      soil: attributes['row_spacing'] != null
          ? 'Spacing: ${attributes['row_spacing']} cm'
          : (attributes['soil'] ?? 'Not specified'),
    );
  }

  factory CareAdvice.fallback() {
    return CareAdvice(
      name: '',
      description: 'Care details not available for this species yet.',
      watering: 'Unknown',
      sunlight: 'Unknown',
      soil: 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'watering': watering,
      'sunlight': sunlight,
      'soil': soil,
    };
  }
}
