import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeGenerator extends StatelessWidget {
  final String qrData;

  QrCodeGenerator({required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: QrImageView(
          data: "1",
          version: QrVersions.auto,
          size: 400.0,
        ),
      ),
    );
  }
}
