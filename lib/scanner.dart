import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  @override
  _QrCodeScannerState createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  String qrCodeResult = "ยังไม่ได้สแกน";

  @override
  void initState() {
    super.initState();
    scanQrCode(); // เรียกใช้ฟังก์ชันสแกน QR Code เมื่อหน้านี้ถูกเรียกขึ้นมา
  }

  Future<void> scanQrCode() async {
    String qrCodeResult = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", // สีของหน้าสแกน
      "ยกเลิก", // ข้อความปุ่มยกเลิก
      true, // อนุญาตให้เปิดแฟลชไฟ (ถ้ามี)
      ScanMode.QR, // โหมดสแกน QR Code
    );

    setState(() {
      this.qrCodeResult = qrCodeResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('กำลังสแกน QR Code...'), // แสดงข้อความในขณะที่กำลังสแกน
            SizedBox(height: 20),
            Text('ผลลัพธ์: $qrCodeResult'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QrCodeScanner(),
  ));
}
