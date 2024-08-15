import 'package:flutter/material.dart';
import 'package:flutter_application_1/orphanage_screens/orphanage_signin_screen.dart';
import '../widgets/custom_scaffold.dart';
import '../widgets/welcome_button.dart';

class OrphanageWelcomeScreen extends StatefulWidget {
  const OrphanageWelcomeScreen({super.key});

  @override
  State<OrphanageWelcomeScreen> createState() => _OrphanageWelcomeScreenState();
}

class _OrphanageWelcomeScreenState extends State<OrphanageWelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                            text: 'Orphange\n',
                            style: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              )),
          const Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Row(
                children: [
                  Expanded(
                    child: WelcomeButton(
                      buttonText: 'Sign in',
                      onTap: OrphanageSigninScreen(),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: WelcomeButton(
                      buttonText: ' ',
                      color: Colors.transparent,
                      textColor: Colors.blue,
                    ),
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
