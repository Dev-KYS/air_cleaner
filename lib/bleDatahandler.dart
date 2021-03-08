import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleDataHandler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}


class BleDataAdapter extends StatefulWidget {
  BluetoothDevice bluetoothDevice;

  @override
  _BleDataAdapter createState() => new _BleDataAdapter();
}


class _BleDataAdapter extends State<BleDataAdapter> {
  receiveMessageToBluetooth() async {
    List<BluetoothService> services = await widget.bluetoothDevice.discoverServices();
    services.forEach((service) async {
      var characteristics = service.characteristics;
      Future.delayed(const Duration(milliseconds: 500), () async {
        for (BluetoothCharacteristic c in characteristics) {
          List<int> value = await c.read();
          print('listing...');
          String stringValue = new String.fromCharCodes(value);
          print('ble data is $stringValue');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}