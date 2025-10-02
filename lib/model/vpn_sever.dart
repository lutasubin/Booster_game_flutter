class VpnServer {
  final String name;
  final String flagPath;
  final String countryCode;

  VpnServer({
    required this.name,
    required this.flagPath,
    required this.countryCode,
  });

  // Danh sách server mặc định
  static List<VpnServer> getDefaultServers() {
    return [
      VpnServer(
        name: 'Germany',
        flagPath: 'assets/flags/de.png',
        countryCode: 'DE',
      ),
      VpnServer(
        name: 'USA',
        flagPath: 'assets/flags/us.png',
        countryCode: 'US',
      ),
      VpnServer(
        name: 'United Kingdom',
        flagPath: 'assets/flags/gb-eng.png',
        countryCode: 'UK',
      ),
      VpnServer(
        name: 'France',
        flagPath: 'assets/flags/fr.png',
        countryCode: 'FR',
      ),
      VpnServer(
        name: 'Singapore',
        flagPath: 'assets/flags/sg.png',
        countryCode: 'SG',
      ),
      VpnServer(
        name: 'Canada',
        flagPath: 'assets/flags/ca.png',
        countryCode: 'CA',
      ),
    ];
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'flagPath': flagPath, 'countryCode': countryCode};
  }

  // Create from JSON
  factory VpnServer.fromJson(Map<String, dynamic> json) {
    return VpnServer(
      name: json['name'] ?? '',
      flagPath: json['flagPath'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is VpnServer &&
        other.name == name &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode => name.hashCode ^ countryCode.hashCode;
}
