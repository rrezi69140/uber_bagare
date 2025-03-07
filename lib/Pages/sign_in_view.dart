import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home.dart';

// Fonction pour la connexion via Google
// Vue de connexion
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _nativeGoogleSignIn(BuildContext context) async {
    SupabaseClient supabase = Supabase.instance.client;

    const webClientId = '1043332455229-vm4d1c7rr1cdfrm2poh8l9998bcl36ag.apps.googleusercontent.com';
    const iosClientId = '1043332455229-mcja895o8onidc74m8aqo893d5voiagf.apps.googleusercontent.com';

    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      print("User cancelled the Google sign-in");
      return;
    }

    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw 'No Access Token or ID Token found.';
    }

    final response = await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      accessToken: accessToken,
      idToken: idToken,
    );

    // Si l'utilisateur est authentifié, on le redirige vers la page d'accueil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Connexion Google",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.black, // Fond noir pour l'AppBar
      ),
      backgroundColor: Colors.black, // Fond noir pour toute la page
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Se connecter via Google :',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white, // Texte en blanc
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _nativeGoogleSignIn(context);  // Connexion via Google
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  // Fond noir pour le bouton
               // Texte du bouton en blanc
                  side: BorderSide(color: Colors.white, width: 1), // Bordure blanche
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8), // Coins arrondis
                  ),
                ),
                child: const Text(
                  'Connexion',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
