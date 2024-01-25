import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sycon_ticketing_app/models/registration.dart';
import 'package:sycon_ticketing_app/services/firestore_services.dart';
import 'package:sycon_ticketing_app/widgets/prompts/qr_scanned_prompt.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  MobileScannerController cameraController = MobileScannerController();
  bool _torchEnabled = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture scanData) async {
    final String scannedCode = scanData.barcodes.first.rawValue ?? "/";
    await cameraController.stop();
    await fetchRegisterInformation(scannedCode)
        .then((registerInformation) async {
      if (registerInformation == null) {
        await showScannedErrorDialog(context);
      } else {
        Registration scannedRegister = registerInformation;
        if (scannedRegister.isEntry) {
          if (!scannedRegister.isLunch && DateTime.now().hour >= 12) {
            scannedRegister.isLunch = true;
            await allowRegisterAccess(scannedCode, isEntry: false).then(
                (value) => showScannedResultBottomSheet(
                    context, scannedRegister, true));
          } else {
            await showScannedResultBottomSheet(context, scannedRegister, false);
          }
        } else {
          scannedRegister.isEntry = true;
          await allowRegisterAccess(scannedCode, isEntry: true).then((value) =>
              showScannedResultBottomSheet(context, scannedRegister, true));
        }
      }
      await cameraController.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: _onDetect,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      (_torchEnabled) ? Icons.flash_on : Icons.flash_off,
                      color: Colors.grey,
                    ),
                    iconSize: 32.0,
                    onPressed: () async {
                      await cameraController.toggleTorch();
                      setState(() {
                        _torchEnabled = !_torchEnabled;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.flip_camera_ios_outlined,
                      color: Colors.grey,
                    ),
                    iconSize: 32.0,
                    onPressed: () {
                      cameraController.switchCamera();
                      setState(() {
                        _torchEnabled = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
