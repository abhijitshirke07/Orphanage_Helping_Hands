import 'package:flutter/material.dart';
import 'package:flutter_application_1/orphanage_screens/orphanage_welcome_screen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';

class SelectuserScreen extends StatefulWidget {
  const SelectuserScreen({super.key});

  @override
  State<SelectuserScreen> createState() => _SelectuserScreenState();
}

class _SelectuserScreenState extends State<SelectuserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg2.png'), // Background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Images
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First Image
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => OrphanageWelcomeScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/orphanage_logo.gif', // First image path
                        width: 300,
                        height: 350,
                      ),
                      Positioned(
                        child: Text(
                          "ORPHANAGE",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        bottom: 70,
                        right: 90,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Space between the images
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => WelcomeScreen()),
                    );
                  },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/images/donations_logo.gif', // Second image path
                        width: 350,
                        height: 300,
                      ),
                      Positioned(
                        child: Text(
                          "DONATION",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                        right: 120,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
