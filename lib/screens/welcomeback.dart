import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bank/screens/home_page.dart';
import 'package:flutter_bank/screens/main_page.dart';
import 'package:local_auth/local_auth.dart';

class WelcomeBackScreen extends StatefulWidget {
  const WelcomeBackScreen({
    Key? key,
  }) : super(key: key);

  @override
  _WelcomeBackScreenState createState() => _WelcomeBackScreenState();
}

class _WelcomeBackScreenState extends State<WelcomeBackScreen> {
  final LocalAuthentication _authService = LocalAuthentication();
  bool _isAuthenticated = false;
  String confirmPin = '';

  void _onKeyPressed(String value) {
    setState(() {
      if (value == 'backspace') {
        if (confirmPin.isNotEmpty) {
          confirmPin = confirmPin.substring(0, confirmPin.length - 1);
        }
      } else if (confirmPin.length < 4) {
        confirmPin += value;
      }
    });
  }

  late final LocalAuthentication auth;
  bool _supportState = false;

  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
      (bool isSupported) {
        setState(() {
          _supportState = isSupported;
        });
      },
    );
  }

  Future<void> authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to complete the transfer',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
      Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
      } else {
        print('Authentication failed');
         ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please set your fingerprint in the settings section your device'),
                    ),
                  );
      }
    } on PlatformException catch (e) {
      print('Authentication error: $e');
    }
  }

  Widget _buildPinDots() {
    List<Widget> dots = [];
    for (int i = 0; i < 4; i++) {
      dots.add(Container(
        height: 30,
        width: 30,
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: CircleAvatar(
          radius: 10,
          backgroundColor:
              i < confirmPin.length ? Colors.black : Colors.grey[300],
        ),
      ));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dots,
    );
  }

  Widget _buildKeypadButton(String value) {
    return GestureDetector(
      onTap: () => _onKeyPressed(value),
      child: Container(
        margin: EdgeInsets.all(15),
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[200],
        ),
        child: Center(
          child: value == 'backspace'
              ? Icon(Icons.backspace_outlined, size: 20)
              : Text(
                  value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('1'),
            _buildKeypadButton('2'),
            _buildKeypadButton('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('4'),
            _buildKeypadButton('5'),
            _buildKeypadButton('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildKeypadButton('7'),
            _buildKeypadButton('8'),
            _buildKeypadButton('9'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: authenticate,
              child: Container(
                margin: EdgeInsets.all(15),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: Center(
                  child: Icon(Icons.fingerprint, size: 24),
                ),
              ),
            ),
            _buildKeypadButton('0'),
            _buildKeypadButton('backspace'),
          ],
        ),
      ],
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('PIN confirmed successfully.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Gilroy Medium'),
            ),
            SizedBox(height: 8),
            Text(
              'Please enter your PIN to continue',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Gilroy Medium'),
            ),
            SizedBox(height: 32),
            _buildPinDots(),
            SizedBox(height: 32),
            _buildKeypad(),
            SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                if (confirmPin == '0000') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(),
                  ),
                );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid PIN. Please enter the correct 4-digit PIN.'),
                    ),
                  );
                }
              },
              child: Text('Enter'),
            ),
          ],
        ),
      ),
    );
  }
}
