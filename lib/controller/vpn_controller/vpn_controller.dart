import 'dart:async';
import 'package:booster_game/model/vpn_sever.dart';
import 'package:get/get.dart';

class VpnController extends GetxController {
  /// Trạng thái VPN (true = đang kết nối, false = ngắt kết nối)
  var isVpnConnected = false.obs;

  /// Server hiện tại
  var currentServer = "Germany".obs;
  var currentFlag = "assets/flags/de.png".obs;

  /// Thời gian kết nối (format: HH:MM:SS)
  var connectionTime = '00:00:00'.obs;

  /// Timer để đếm thời gian kết nối
  Timer? _connectionTimer;
  int _secondsElapsed = 0;

  /// Danh sách servers có sẵn
  List<VpnServer> availableServers = [];

  @override
  void onInit() {
    super.onInit();
    // Load danh sách servers
    availableServers = VpnServer.getDefaultServers();
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  /// Toggle VPN On/Off
  void toggleVpn(bool status) {
    isVpnConnected.value = status;

    if (status) {
      // Bật VPN - bắt đầu đếm thời gian
      _startTimer();
      // TODO: Add your VPN connect logic here
      // Example: await vpnService.connect(currentServer.value);
    } else {
      // Tắt VPN - dừng và reset timer
      _stopTimer();
      // TODO: Add your VPN disconnect logic here
      // Example: await vpnService.disconnect();
    }
  }

  /// Đổi server
  void changeServer(String serverName, String flagPath) {
    currentServer.value = serverName;
    currentFlag.value = flagPath;

    // Nếu đang kết nối, reconnect với server mới
    if (isVpnConnected.value) {
      _reconnect();
    }
  }

  /// Chọn server theo object VpnServer
  void selectServer(VpnServer server) {
    changeServer(server.name, server.flagPath);
  }

  /// Bắt đầu đếm thời gian kết nối
  void _startTimer() {
    // Reset về 0 trước khi bắt đầu
    _secondsElapsed = 0;
    connectionTime.value = '00:00:00';

    // Tạo timer đếm mỗi giây
    _connectionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        _secondsElapsed++;
        connectionTime.value = _formatTime(_secondsElapsed);
      },
    );
  }

  /// Dừng và reset timer
  void _stopTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
    _secondsElapsed = 0;
    connectionTime.value = '00:00:00';
  }

  /// Reconnect khi đổi server
  void _reconnect() {
    // TODO: Add reconnection logic
    // Example:
    // await vpnService.disconnect();
    // await vpnService.connect(currentServer.value);
    
    _stopTimer();
    // Delay nhỏ để có hiệu ứng reconnect
    Future.delayed(const Duration(milliseconds: 500), () {
      if (isVpnConnected.value) {
        _startTimer();
      }
    });
  }

  /// Format giây thành HH:MM:SS
  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  /// Get thời gian kết nối dạng text (để hiển thị)
  String get connectionDuration => connectionTime.value;

  /// Get số giây đã kết nối
  int get secondsConnected => _secondsElapsed;

  /// Check xem server có đang được chọn không
  bool isServerSelected(String serverName) {
    return currentServer.value == serverName;
  }

  /// Get current server object
  VpnServer? get currentServerObject {
    try {
      return availableServers.firstWhere(
        (server) => server.name == currentServer.value,
      );
    } catch (e) {
      return null;
    }
  }
}