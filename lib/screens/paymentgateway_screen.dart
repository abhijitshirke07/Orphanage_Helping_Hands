import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/stripe_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentgatewayScreen extends StatefulWidget {
  final int amt;
  const PaymentgatewayScreen({super.key, required this.amt});

  @override
  State<PaymentgatewayScreen> createState() => _PaymentgatewayScreenState();
}
//
// Future<void> makePayment(BuildContext context) async {
//   try {
//     // Step 1: Create a PaymentIntent
//     final paymentIntentData = await createPaymentIntent('1000', 'usd');
//
//     // Step 2: Initialize payment sheet
//     await Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntentData['clientSecret'],
//         merchantDisplayName: 'Your Merchant Name',
//       ),
//     );
//
//     // Step 3: Display payment sheet
//     await Stripe.instance.presentPaymentSheet();
//
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Successful!")),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Payment Failed: $e")),
//     );
//     print(e);
//   }
// }
//
// Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
//   try {
//     Map<String, dynamic> body = {
//       'amount': amount,
//       'currency': currency,
//     };
//
//     var http;
//     var response = await http.post(
//       Uri.parse('http://10.0.2.2:3000/create-payment-intent'),
//       body: jsonEncode({'amount': amount, 'currency': currency}),
//       headers: {'Content-Type': 'application/json'},
//     );
//
//     return jsonDecode(response.body);
//   } catch (err) {
//     throw Exception(err.toString());
//     print(err);
//   }
// }

class _PaymentgatewayScreenState extends State<PaymentgatewayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: ()async {
              StripeService.instance.makePayment(widget.amt);
            },
            child: Text("pay",
              style: TextStyle(
                fontSize: 20.0,
              ),)
        ),
      )
    );
  }
}





















































// import 'dart:convert';


//
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
//
// class PaymentgatewayScreen extends StatefulWidget {
//   final int donation_amount;
//   const PaymentgatewayScreen({super.key, required this.donation_amount});
//
//   @override
//   State<PaymentgatewayScreen> createState() => _PaymentgatewayScreenState();
// }
//
// class _PaymentgatewayScreenState extends State<PaymentgatewayScreen> {
//   String environmentValue = "UAT_SIM";
//   String appId = "";
//   String merchantId = "PGTESTPAYUAT86";
//   bool enableLogging = true;
//   String saltKey = "96434309-7796-489d-8924-ab56988a6076";
//   String saltIndex = "3";
//   String body = "";
//   Object? result;
//
//   String callback = "https://webhook.site/9f52095e-7041-4f8a-8149-66663a4020f3";
//   String checksum = "";
//   String packageName = "";
//   String apiEndPpoint = "/pg/v1/pay";
//
//   @override
//   void initState() {
//     super.initState();
//     initPayment();
//     body = getChecksum();
//   }
//
//   void initPayment() {
//     PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
//         .then((val) {
//       setState(() {
//         result = 'PhonePe SDK Initialized - $val';
//       });
//     }).catchError((error) {
//       handleError(error);
//     });
//   }
//
//   void handleError(error) {
//     setState(() {
//       result = {"error": error};
//     });
//   }
//
//   void startpgTransaction() {
//     PhonePePaymentSdk.startTransaction(body, callback, checksum, packageName)
//         .then((response) {
//       setState(() {
//         if (response != null) {
//           String status = response['status'].toString();
//           String error = response['error'].toString();
//           if (status == 'SUCCESS') {
//             result = "Flow Completed - Status Successful";
//           } else {
//             result = "Flow Completed - Status $status and Error: $error";
//           }
//         } else {
//           result = "Flow Incompleted";
//         }
//       });
//     }).catchError((error) {
//       handleError(error);
//     });
//   }
//
//   String getChecksum() {
//     final reqData = {
//       "merchantId": merchantId,
//       "merchantTransactionId": "transaction_123",
//       "merchantUserId": "90223250",
//       "amount": widget.donation_amount,
//       "mobileNumber": "9999999999",
//       "callbackUrl": "https://webhook.site/callback-url",
//       "paymentInstrument": {
//         "type": "UPI_INTENT",
//         "targetApp": "com.phonepe.app"
//       },
//       "deviceContext": {
//         "deviceOS": "ANDROID"
//       }
//     };
//
//     String base64body = base64.encode(utf8.encode(json.encode(reqData)));
//
//     try {
//       checksum = '${sha256.convert(utf8.encode(base64body + apiEndPpoint + saltKey)).toString()}###$saltIndex';
//     } catch (error) {
//       print('Error calculating checksum: $error');
//     }
//
//     return base64body;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Payment Gateway'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: ElevatedButton(
//               child: Text('Pay now'),
//               onPressed: () {
//                 startpgTransaction();
//               },
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(result.toString()),
//           ),
//         ],
//       ),
//     );
//   }
// }
