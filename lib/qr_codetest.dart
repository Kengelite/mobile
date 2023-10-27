import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QRCodeScreen extends StatelessWidget {
  // final String imageUrl; // URL ของรูปภาพที่ได้จาก API
  const QRCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save image to gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: saveSreen(),
    );

  }
}

class saveSreen extends StatefulWidget {
  const saveSreen({super.key});

  @override
  State<saveSreen> createState() => _saveSreenState();
}

class _saveSreenState extends State<saveSreen> {
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _requestPermission();
  }

  _requestPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();

    final info = statuses[Permission.storage].toString();
    print(info);
    _toastInfo(info);
  }

  _saveScreen() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
        as FutureOr<ByteData?>);
    if (byteData != null) {
      final result =
          await ImageGallerySaver.saveImage(byteData.buffer.asUint8List());
      print(result);
      _toastInfo(result.toString());
    }
  }

  _toastInfo(String info) {
    Fluttertoast.showToast(msg: info, toastLength: Toast.LENGTH_LONG);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code'),
      ),
      body: Center(
        child: Column(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: Container(
                width: 200,
                height: 200,
                color: Colors.white,
                child: QrImageView(
                  data:
                      '00020101021230830016A0000006770101120115010556006812748021800000023051903559203180000000WESDSS55222530376454041.105802TH5910GBPrimePay63045E7F',
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveScreen,
              // () => saveQRCode(context),
              child: Text('Save QR Code'),
            ),
          ],
        ),
      ),
    );
  }
}
