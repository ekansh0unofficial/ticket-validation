import 'package:advaita_ticket_validator/authentication/login_backend.dart';
import 'package:advaita_ticket_validator/scanner/authenticator.dart';
import 'package:advaita_ticket_validator/scanner/validator.dart';
import 'package:advaita_ticket_validator/utilities/user_type.dart';
import 'package:advaita_ticket_validator/utilities/my_alert_box.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import '../authentication/login.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  String? qrCode;
  bool isScanning = false;
  bool poppedUp = false;
  String userType = "Loading...";

  @override
  void initState() {
    super.initState();
    fetchUserType();
  }

  Future<void> fetchUserType() async {
    String? type = await SharedPrefHelper.getUserType();
    setState(() {
      userType = type ?? "Unknown User";
    });
  }

  Future<void> function(BuildContext context) async {
    String? s = await SharedPrefHelper.getUserType();
    String out = "";
    print('User is of type: $s');

    if (s == 'validator') {
      out = await Validator().create(qrCode!);
      print('Coupon created');
    } else if (s == 'authenticator') {
      out = await Authenticator().welcome(qrCode!);
    } else {
      print('Invalid user type');
    }

    // Stop scanning while the popup is active
    setState(() {
      isScanning = true;
      poppedUp = true;
    });

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Scanned QR Code:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      qrCode ?? "No QR code detected",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                  const SizedBox(height: 10),
                  MyAlertbox(message: out),
                ],
              ),
            ),
            Positioned(
              right: 10,
              top: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    ).whenComplete(() async {
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        isScanning = false;
        poppedUp = false;
      });
    });
  }

  void logout(BuildContext context) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    await loginViewModel.logout(context);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userType == "validator" ? "Validator" : "Authenticator"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                MobileScanner(
                  onDetect: (capture) {
                    if (isScanning || poppedUp) return;
                    setState(() {
                      isScanning = true;
                      poppedUp = true;
                    });
                    final List<Barcode> barcodes = capture.barcodes;
                    for (final barcode in barcodes) {
                      if (barcode.rawValue != null) {
                        setState(() {
                          qrCode = barcode.rawValue!;
                        });
                        function(context);
                        print('Function called');
                      }
                    }
                  },
                ),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red, width: 6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scan a QR Code",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Position the QR code inside the red box",
                    style: TextStyle(color: Colors.grey),
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
