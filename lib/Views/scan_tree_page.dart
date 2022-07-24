import 'dart:io';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tree_ar/data_manager.dart';

import 'package:tree_ar/constant_vars.dart';
import 'package:tree_ar/main.dart';
import 'Ar_Views/ar_info_ar_screen.dart';

class ScanTreePage extends StatefulWidget {
  const ScanTreePage({Key? key}) : super(key: key);

  @override
  State<ScanTreePage> createState() => _ScanTreePageState();
}

class _ScanTreePageState extends State<ScanTreePage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool showErrorSnackBar = false;
  Barcode? result;
  bool qrCodeFound = false;
  QRViewController? controller;

  DateTime lastScanTime = DateTime.now();
  final Duration timeoutScan = const Duration(seconds: 4);

  @override
  Widget build(BuildContext buildContext) {
    return Scaffold(
        body: SafeArea(
      child: Stack(children: [
        //   if (loadFinished && !isValid) {
        //     setState(() {
        //       showErrorSnackBar = true;
        //     });
        //   }

        //   if (loadFinished && isValid) {
        //     controller!.pauseCamera();
        //     dataManager.addUserTree(tree!.treeId);
        //   }
        //   return TreeViewInfoAr(
        //     tree: tree!,
        //     proj: proj!,
        //   );
        // },
        Consumer<DataManager>(
          builder: (context, dataMgr, child) {
            var tree = dataMgr.treeByQrCodeId;
            var proj = dataMgr.projByQrCodeId;
            var isValid = dataMgr.qrIsValid;
            var loadFinished = dataMgr.loadHasFinished;
            dataMgr.resetCacheVars();

            if (loadFinished && !isValid) {
              showSnackError();
            }
            if (loadFinished && isValid) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Text("pagina correttta"),
                ),
              );
            }

            return QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                setState(() {
                  this.controller = controller;
                });

                controller.scannedDataStream.listen((scanData) {
                  if (DateTime.now().difference(lastScanTime) > timeoutScan) {
                    lastScanTime = DateTime.now();

                    var qrData = scanData.code ?? "";
                    dataMgr.isValidTreeCode(qrData);
                  }
                });
              },
              overlay: QrScannerOverlayShape(
                  borderColor: mainColor,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 20),
              onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
            );
          },
        )
      ]),
    ));
  }

  void showSnackError() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("QRcode non valido o albero non trovato"),
      duration: Duration(seconds: 2),
    ));
  }

  void resetView() {
    setState(() {
      result = null;
      controller!.resumeCamera();
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera Permission')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }
}
