import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bank/screens/pin.dart';
import 'package:local_auth/local_auth.dart';

class MoneyTransferScreen extends StatefulWidget {
  @override
  _MoneyTransferScreenState createState() => _MoneyTransferScreenState();
}

class _MoneyTransferScreenState extends State<MoneyTransferScreen> {
  final LocalAuthentication _authService = LocalAuthentication();
  bool _isAuthenticated = false;

  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController accountNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController narrationController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedBank;

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
        _showSuccessDialog();
      } else {
        print('Authentication failed');
      }
    } on PlatformException catch (e) {
      print('Authentication error: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Transfer Completed Successfully!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Transfer'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to transfer \$${amountController.text} to ${accountNameController.text} at ${bankController.text}?',
              ),
              TextField(
                controller: pinController,
                decoration: InputDecoration(labelText: 'Enter PIN'),
                obscureText: true,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                if (pinController.text == '1234') {
                  _showSuccessDialog();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid PIN'),
                    ),
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Money Transfer'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: accountNumberController,
                  decoration: InputDecoration(
                      labelText: 'Enter 11-digit account number'),
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  onChanged: (value) {
                    if (value.length == 11) {
                      // Perform name inquiry
                      setState(() {
                        accountNameController.text = 'Default Account Name';
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an account number';
                    }
                    if (value.length != 11) {
                      return 'Account number must be 11 digits';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  value: selectedBank,
                  decoration: InputDecoration(labelText: 'Select Bank'),
                  items: [
                    'OPAY',
                    'WEMA',
                    'UBA',
                    'FIRSTBANK',
                    'PALMPAY',
                    'ACCESS',
                    'ECOBANK',
                    'GTB',
                    'HERITAGE BANK',
                    'KUDA',
                    'Zenith Bank',
                    'First City Monument Bank Limited',
                    'Fidelity Bank PLC',
                    'Union Bank of Nigeria',
                    'Stanbic IBTC Bank Plc',
                    'Sterling Bank Plc',
                    'Mutual Trust Microfinance Bank',
                    'FairMoney Microfinance Bank',
                  ].map((String bank) {
                    return DropdownMenuItem<String>(
                      value: bank,
                      child: Text(bank),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedBank = newValue;
                      bankController.text = newValue!;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a bank' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: accountNameController,
                  decoration: InputDecoration(labelText: 'Account Name'),
                  readOnly: true,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: amountController,
                  decoration:
                      InputDecoration(labelText: 'Enter Amount to Send'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: narrationController,
                  decoration: InputDecoration(labelText: 'Enter Narration'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a narration';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConfirmWallet(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content:
                                  Text('Please fill all fields correctly')),
                        );
                      }
                    },
                    child: Text('Send'),
                  ),
                ),
                // SizedBox(height: 20),
                // Text('Or use Fingerprint to send'),
                // ElevatedButton(
                //   onPressed: authenticate,
                //   child: Text('Authenticate with Fingerprint'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
