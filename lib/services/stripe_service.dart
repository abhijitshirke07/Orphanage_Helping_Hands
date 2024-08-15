import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../screens/consts.dart';

class StripeService{
 StripeService._();

 static final StripeService instance = StripeService._();

 Future<void> makePayment(int amt) async{
   try{
     String? paymentIntelClientSecret = await _createPaymentIntent(amt, 'USD');

     if(paymentIntelClientSecret == null)return;
     await Stripe.instance.initPaymentSheet(
         paymentSheetParameters: SetupPaymentSheetParameters(
           paymentIntentClientSecret: paymentIntelClientSecret,
           merchantDisplayName: 'Abhijit',
         ),
     );
     await _processPayement();
   }catch(e){
     print(e);
   }
 }

 Future<String?> _createPaymentIntent(int amount, String currency) async{
   try{
     final Dio dio = Dio();
     Map<String, dynamic> data = {
       "amount": _calculateamount(amount),
       "currency":currency,
     };
     var response = await dio.post(
       "https://api.stripe.com/v1/payment_intents",
       data: data,
       options: Options(
         contentType: Headers.formUrlEncodedContentType,
         headers: {
           "Authorization": "Bearer $stripesecretkey",
           "Content-Type": 'application/x-www-form-urlencoded'
         },
       )
     );
     if(response.data !=null){
       return response.data['client_secret'];
     }
     return null;
   }catch(e){
     print(e);
   }
   return null;
 }

 String _calculateamount(int amount){
   final calculatedamount = amount *100;
   return calculatedamount.toString();
 }

 Future<void> _processPayement() async{
   try{
     await Stripe.instance.presentPaymentSheet();
   }catch(e){
     print(e);
   }
 }
}