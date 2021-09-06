import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cancoin_wallet/global.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

typedef OnScanned = void Function(String? address);

class QRCodeReaderPage extends StatefulWidget {
  const QRCodeReaderPage({
    Key? key,
    this.closeWhenScanned = true,
  }) : super(key: key);

  final bool closeWhenScanned;

  @override
  State<StatefulWidget> createState() => _QRCodeReaderPageState();
}

class _QRCodeReaderPageState extends State<QRCodeReaderPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  // static final RegExp _basicAddress = RegExp(r'^(0x)?[0-9a-f]{40}', caseSensitive: false);

  StreamSubscription? _subscription;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanArea = (Get.width < 400 ||
        Get.height < 400)
        ? 270.0
        : 450.0;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              )
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    _subscription = controller.scannedDataStream.listen((scanData) {
      final address = scanData.code;
      if (widget.closeWhenScanned) {
        _subscription?.cancel();
        Get.back(result: address);
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
