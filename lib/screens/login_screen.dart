import 'package:bha_app_vendor/screens/landing_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String id = 'login-screen';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      // If the user is already signed-in, use it as initial data
      initialData: FirebaseAuth.instance.currentUser,
      builder: (context, snapshot) {
        // User is not signed in
        if (!snapshot.hasData) {
          return SignInScreen(
              showAuthActionSwitch: false,
              subtitleBuilder: (context, action) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Welcome to BhaApp-Vendor! Please sign in to continue.'
                        : 'Welcome to BhaApp-Vendor! Please create an account to continue',
                  ),
                );
              },
              footerBuilder: (context, _) {
                return const Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text(
                    'By signing in, you agree to our terms and conditions.',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              },
              headerBuilder: (context, constraints, _) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 40,
                            child: Center(
                                child:
                                    Image.asset('assets/images/bha_app_logo.png'),
                              ),
                          ),
                          Text(
                            'Vendor',
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    //child: Image.asset('assets/images/bha_app_logo.png'),
                  ),
                );
              },
              providerConfigs: const [
                //GoogleProviderConfiguration(clientId: '1:711167476501:android:069d43160361d1c415df1c'),
                PhoneProviderConfiguration(),
              ]);
        }
        // Render your application if authenticated
        return const LandingScreen();
        //return const RegistrationScreen();
      },
    );
  }
}
