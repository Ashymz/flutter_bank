import 'package:flutter/material.dart';
import 'package:flutter_bank/screens/pin.dart';

class VtuScreen extends StatefulWidget {
  @override
  _VtuScreenState createState() => _VtuScreenState();
}

class _VtuScreenState extends State<VtuScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  String? selectedProvider;
  String? selectedPlan;

  final List<String> providers = ['GLO', 'AIRTEL', 'ETISALAT', 'MTN'];
  final Map<String, List<String>> plans = {
    'GLO': ['1GB - N500', '2GB - N1000', '5GB - N2000'],
    'AIRTEL': ['1GB - N600', '2GB - N1200', '5GB - N2500'],
    'ETISALAT': ['1GB - N550', '2GB - N1100', '5GB - N2200'],
    'MTN': ['1GB - N650', '2GB - N1300', '5GB - N2700'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Data'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Provider'),
                  value: selectedProvider,
                  items: providers.map((String provider) {
                    return DropdownMenuItem<String>(
                      value: provider,
                      child: Text(provider),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedProvider = newValue;
                      selectedPlan = null; // Reset the selected plan
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a provider' : null,
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Select Plan'),
                  value: selectedPlan,
                  items: selectedProvider == null
                      ? []
                      : plans[selectedProvider]!.map((String plan) {
                          return DropdownMenuItem<String>(
                            value: plan,
                            child: Text(plan),
                          );
                        }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedPlan = newValue;
                    });
                  },
                  validator: (value) =>
                      value == null ? 'Please select a plan' : null,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Enter Phone Number'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a phone number';
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
                              builder: (context) => ConfirmWallet()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Processing Purchase...')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please fill all fields')),
                        );
                      }
                    },
                    child: Text('Buy Data'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
