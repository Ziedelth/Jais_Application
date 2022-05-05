import 'package:flutter/material.dart';
import 'package:jais/models/member.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRMember extends StatefulWidget {
  final Member member;

  const QRMember({required this.member, Key? key}) : super(key: key);

  @override
  _QRMemberState createState() => _QRMemberState();
}

class _QRMemberState extends State<QRMember> {
  bool darkMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('QR Code'),
        actions: [
          if (darkMode)
            IconButton(
              icon: const Icon(Icons.light_mode),
              onPressed: () {
                setState(() {
                  darkMode = false;
                });
              },
            ),
          if (!darkMode)
            IconButton(
              icon: const Icon(Icons.dark_mode),
              onPressed: () {
                setState(() {
                  darkMode = true;
                });
              },
            )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: QrImage(
            foregroundColor: darkMode ? Colors.white : Colors.black,
            data: 'jais:member:${widget.member.pseudo}',
            size: 200,
            errorStateBuilder: (cxt, err) {
              return const Center(
                child: Text(
                  "Uh oh! Something went wrong...",
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
