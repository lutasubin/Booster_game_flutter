import 'dart:async';
import 'package:booster_game/model/vpn_sever.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnController extends GetxController {
  /// Trạng thái VPN
  var isVpnConnected = false.obs;

  /// Server hiện tại
  var currentServer = VpnServer.getDefaultServers().first.obs;

  /// Thời gian kết nối dạng HH:MM:SS
  var connectionTime = '00:00:00'.obs;

  /// Log & Stage VPN
  var vpnLog = ''.obs;
  var vpnStage = VPNStage.disconnected.obs;

  /// Timer đếm thời gian
  Timer? _connectionTimer;
  int _secondsElapsed = 0;

  /// OpenVPN instance
  late OpenVPN openvpn;

  @override
  void onInit() {
    super.onInit();

    openvpn = OpenVPN(
      onVpnStatusChanged: _onVpnStatusChanged,
      onVpnStageChanged: _onVpnStageChanged,
    );

    openvpn.initialize(
      groupIdentifier: "group.com.example.vpn",
      providerBundleIdentifier: "id.example.vpn.VPNExtension",
      localizedDescription: "Example VPN",
    );
  }

  @override
  void onClose() {
    _stopTimer();
    super.onClose();
  }

  /// Xử lý trạng thái chi tiết VPN
  void _onVpnStatusChanged(VpnStatus? status) {
    // Bạn có thể lưu log download/upload, packets, duration nếu muốn
  }

  /// Xử lý stage & log
  void _onVpnStageChanged(VPNStage stage, String log) {
    vpnLog.value = log;

    if (stage == VPNStage.connected) {
      vpnStage.value = VPNStage.connected;
      isVpnConnected.value = true;
      _startTimer();
    } else if (stage == VPNStage.disconnected) {
      vpnStage.value = VPNStage.disconnected;
      isVpnConnected.value = false;
      _stopTimer();
    }
    // Không gán connecting ở đây
  }

  /// Connect VPN từ server hiện tại
  Future<void> connect() async {
    try {
      // Cập nhật trạng thái connecting để UI hiện
      vpnStage.value = VPNStage.connecting;

      // Delay nhỏ để UI kịp rebuild trạng thái connecting
      await Future.delayed(const Duration(milliseconds: 100));

      final config = await rootBundle.loadString(currentServer.value.vpnPath);

      openvpn.connect(
        config,
        'MyVPN',
        username: '',
        password: '',
        bypassPackages: [],
        certIsRequired: false,
      );
    } catch (e) {
      vpnLog.value = 'Lỗi load config: $e';
      vpnStage.value = VPNStage.disconnected;
    }
  }

  /// Disconnect VPN
  void disconnect() {
    openvpn.disconnect();
  }

  /// Toggle VPN On/Off
  void toggleVpn() {
    if (isVpnConnected.value) {
      disconnect();
    } else {
      connect();
    }
  }

  /// Chọn server mới
  void selectServer(VpnServer server) {
    currentServer.value = server;

    // Nếu đang kết nối, reconnect với server mới
    if (isVpnConnected.value) {
      disconnect();
      Future.delayed(const Duration(milliseconds: 500), () => connect());
    }
  }

  /// Timer đếm thời gian kết nối
  void _startTimer() {
    _secondsElapsed = 0;
    connectionTime.value = '00:00:00';

    _connectionTimer?.cancel();
    _connectionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsElapsed++;
      connectionTime.value = _formatTime(_secondsElapsed);
    });
  }

  void _stopTimer() {
    _connectionTimer?.cancel();
    _connectionTimer = null;
    _secondsElapsed = 0;
    connectionTime.value = '00:00:00';
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${secs.toString().padLeft(2, '0')}';
  }

  /// Lấy danh sách server
  List<VpnServer> get servers => VpnServer.getDefaultServers();
}
