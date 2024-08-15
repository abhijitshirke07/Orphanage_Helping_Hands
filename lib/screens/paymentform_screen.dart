import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';

class PaymentFormScreen extends StatelessWidget {
  final String orphanageName;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upidController = TextEditingController();
  final String useremail;
  final String orphanageemail;
  PaymentFormScreen({required this.orphanageName, required this.orphanageemail, required this.useremail});

  Future<void> insertPayment({
    required BuildContext context,
  }) async {
    try {
      String amount = _amountController.text;
      Timestamp currentDate = Timestamp.now();
      // Create a map with the payment data
      Map<String, dynamic> paymentData = {
        'amount': _amountController.text,
        'date': currentDate,
        'email': useremail,
        'orphanageName': orphanageName,
        'orphanage_email': orphanageemail,
        'upid': _upidController.text ,
      };

      // Insert the payment data into the 'history' collection
      await FirebaseFirestore.instance.collection('history').add(paymentData);

      print('Payment record inserted successfully.');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Payment Successful'),
            content: Text('Your payment of \$${amount} has been successfully processed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(useremail: useremail),
                    ),
                  );                },
                child: Text('OK',
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error inserting payment record: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate to Orphanage'),
        backgroundColor: Colors.blue[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Orphanage Name:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue[900],
                  ),
                ),
                SizedBox(height: 10.0),
                Text(
                  orphanageName, // Using the passed orphanageName
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.lightBlue[700],
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  'Amount:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue[900],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter amount to donate',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                  ),
                ),
                Text(
                  'UPID:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlue[900],
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _upidController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Enter UPID',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 14.0,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      insertPayment(context: context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      backgroundColor: Colors.green, // Set button color to green
                    ),
                    child: Text(
                      'Donate',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
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
