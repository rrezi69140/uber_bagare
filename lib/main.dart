import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Pages/sign_in_view.dart';


import 'Pages/home.dart';
import 'model/position_model.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  MapboxOptions.setAccessToken(dotenv.get('MAPBOX_ACCESS_TOKEN'));

  await Supabase.initialize(
    url: 'https://ygpylukohmoalndwsaqp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlncHlsdWtvaG1vYWxuZHdzYXFwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDAxMzQ1MTUsImV4cCI6MjA1NTcxMDUxNX0.NdbPkQmKj4rjG7w5cEOdVf0nqQ8putdvVs3IGQmgL8o',
  );

  runApp(

    ChangeNotifierProvider(
      create: (context) => PositionProvider(),
      child: MaterialApp(
        title: "UberBagarre",
        home: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LoginView();
  }
}
