import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:ui';

import 'package:flutter_ble/flutter_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlassSupport {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  FlutterBle _flutterBlue = FlutterBle.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  Map<DeviceIdentifier, ScanResult> scanResults = new Map();
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  /// Device
  BluetoothDevice device;

  bool get isConnected => (device != null);
  StreamSubscription deviceConnection;
  StreamSubscription deviceStateSubscription;
  List<BluetoothService> services = new List();
  Map<Guid, StreamSubscription> valueChangedSubscriptions = {};
  BluetoothDeviceState deviceState = BluetoothDeviceState.disconnected;

  static const String CHARACTERISTIC_UUID =
      "297e4ec2-01a5-11ea-8d71-362b9e155667";
  static const String kMYDEVICE = "myDevice";
  String _myDeviceId;

  //Picture _photo;
  String _photo; //will replace with a picture?

  _loadMyDeviceId() async {
    SharedPreferences prefs = await _prefs;
    _myDeviceId = prefs.getString(kMYDEVICE) ?? "";
    print("_myDeviceId : " + _myDeviceId);

    if (_myDeviceId.isNotEmpty) {
      _startScan();
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;
  }

  _startScan() {
    _scanSubscription = _flutterBlue
        .scan(
      timeout: const Duration(seconds: 5),
      /*withServices: [
          new Guid('0000180F-0000-1000-8000-00805F9B34FB')
        ]*/
    )
        .listen((scanResult) {
//      print('localName: ${scanResult.advertisementData.localName}');
//      print(
//          'manufacturerData: ${scanResult.advertisementData.manufacturerData}');
//      print('serviceData: ${scanResult.advertisementData.serviceData}');

      if (_myDeviceId == scanResult.device.id.toString()) {
        _stopScan();
        _connect(scanResult.device);
      }

      scanResults[scanResult.device.id] = scanResult;
    }, onDone: _stopScan);

    isScanning = true;
  }

  _stopScan() {
    _scanSubscription?.cancel();
    _scanSubscription = null;
    isScanning = false;
  }

  _connect(BluetoothDevice d) async {
    device = d;
    // Connect to device
    deviceConnection = _flutterBlue
        .connect(device, timeout: const Duration(seconds: 4))
        .listen(
          null,
          onDone: _disconnect,
        );

    // Update the connection state immediately
    device.state.then((s) {
      deviceState = s;
    });

    // Subscribe to connection changes
    deviceStateSubscription = device.onStateChanged().listen((s) {
      deviceState = s;

      if (s == BluetoothDeviceState.connected) {
        device.discoverServices().then((s) {
          services = s;

          print("*** device.id : ${device.id.toString()}");

          _restoreDeviceId(device.id.toString());
          _TurnOnCharacterService();
        });
      }
    });
  }

  _disconnect() {
    // Remove all value changed listeners
    valueChangedSubscriptions.forEach((uuid, sub) => sub.cancel());
    valueChangedSubscriptions.clear();
    deviceStateSubscription?.cancel();
    deviceStateSubscription = null;
    deviceConnection?.cancel();
    deviceConnection = null;

    device = null;
  }

  _readCharacteristic(BluetoothCharacteristic c) async {
    await device.readCharacteristic(c);
  }

  _writeCharacteristic(BluetoothCharacteristic c) async {
    await device.writeCharacteristic(c, [0x12, 0x34],
        type: CharacteristicWriteType.withResponse);
  }

  _readDescriptor(BluetoothDescriptor d) async {
    await device.readDescriptor(d);
  }

  _writeDescriptor(BluetoothDescriptor d) async {
    await device.writeDescriptor(d, [0x12, 0x34]);
  }

  _setNotification(BluetoothCharacteristic c) async {
    if (c.isNotifying) {
      await device.setNotifyValue(c, false);
      // Cancel subscription
      valueChangedSubscriptions[c.uuid]?.cancel();
      valueChangedSubscriptions.remove(c.uuid);
    } else {
      await device.setNotifyValue(c, true);
      // ignore: cancel_subscriptions
      final sub = device.onValueChanged(c).listen((d) {
        final decoded = utf8.decode(d);
        _DataParser(decoded);
      });
      // Add to map
      valueChangedSubscriptions[c.uuid] = sub;
    }
  }

  _refreshDeviceState(BluetoothDevice d) async {
    var state = await d.state;

    deviceState = state;
    print('State refreshed: $deviceState');
  }

  Future<void> _restoreDeviceId(String id) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(kMYDEVICE, id);
  }

  _TurnOnCharacterService() {
    services.forEach((service) {
      service.characteristics.forEach((character) {
        if (character.uuid.toString() == CHARACTERISTIC_UUID) {
          _setNotification(character);
        }
      });
    });
  }

  _DataParser(String data) {
    if (data.isNotEmpty) {
      var photoValue = data.split(",")[0];

      _photo = photoValue;
    }
  }
}
