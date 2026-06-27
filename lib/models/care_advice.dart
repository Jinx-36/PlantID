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
    final attributes = json['attributes'];
    return CareAdvice(
      name: attributes['name'] ?? 'Unknown',
      description: attributes['description'] ?? 'No description available.',
      watering: attributes['sowing_method'] ?? 'Not specified',
      sunlight: attributes['sun_requirements'] ?? 'Not specified',
      soil: attributes['row_spacing'] != null
          ? 'Spacing: ${attributes['row_spacing']} cm'
          : 'Not specified',
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
