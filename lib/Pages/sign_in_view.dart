import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';


import 'home.dart';


// Fonction pour la connexion via Google


// Vue de connexion
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => LogiViewState();


}

class LogiViewState extends State<LoginView>{
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

    // if (response.error != null) {
    //   print('Error: ${response.error!.message}');
    //   return;
    // }

    // Si l'utilisateur est authentifié, on le redirige vers la page d'accueil
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion Google",style: TextStyle(fontSize: 30))),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,spacing: 10
        ,children: [Row(mainAxisAlignment: MainAxisAlignment.center,children: [Text('Se connecter via google :',style: TextStyle(fontSize: 20),)],),Row(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: [Center(
          child: ElevatedButton(
            onPressed: () async {
              await _nativeGoogleSignIn(context);  // Connexion via Google
            },
            child: Text('Connexion'),
          ),
        ),],)],)


    );
  }
}
