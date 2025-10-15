class VpnServer {
  final String name;
  final String flagPath;
  final String countryCode;
  final String vpnPath;

  VpnServer({
    required this.name,
    required this.flagPath,
    required this.countryCode,
    required this.vpnPath
  });

  // Danh sách server mặc định
  static List<VpnServer> getDefaultServers() {
    return [
      VpnServer(
        name: 'Germany',
        flagPath: 'assets/flags/de.png',
        countryCode: 'DE', 
        vpnPath: 'assets/vpn/vpn-germany5.ovpn',
      ),
      VpnServer(
        name: 'USA',
        flagPath: 'assets/flags/us.png',
        countryCode: 'US', 
        vpnPath: 'assets/vpn/vpn-US.ovpn',
      ),
      VpnServer(
        name: 'United Kingdom',
        flagPath: 'assets/flags/gb-eng.png',
        countryCode: 'UK',
         vpnPath: 'assets/vpn/vpn-UK.ovpn',
      ),
      VpnServer(
        name: 'France',
        flagPath: 'assets/flags/fr.png',
        countryCode: 'FR',
         vpnPath: 'assets/vpn/vpn-francectb.ovpn',
      ),
      VpnServer(
        name: 'Singapore',
        flagPath: 'assets/flags/sg.png',
        countryCode: 'SG',
         vpnPath: 'assets/vpn/vpn-singapore5.ovpn',
      ),
      VpnServer(
        name: 'Canada',
        flagPath: 'assets/flags/ca.png',
        countryCode: 'CA', 
        vpnPath: 'assets/vpn/vpn-canada.ovpn',
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
      vpnPath: json['vpnPath']??''
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
