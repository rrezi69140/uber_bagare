// firebase_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseService {
  // Méthode pour gérer les messages reçus en premier plan
  static Future<void> _onMessageReceived(RemoteMessage message) async {
    print("Message reçu : ${message.notification?.title}");
    // Tu peux ajouter ta logique ici, par exemple afficher une notification
  }

  // Méthode pour gérer les messages reçus en arrière-plan
  static Future<void> _onBackgroundMessage(RemoteMessage message) async {
    print("Message reçu en arrière-plan : ${message.notification?.title}");
    // Gérer le message reçu en arrière-plan
  }

  // Méthode pour configurer Firebase Messaging
  static Future<void> setupFirebaseMessaging() async {
    // Configurer l'écoute des messages en premier plan
    FirebaseMessaging.onMessage.listen(_onMessageReceived);

    // Configurer l'écoute des messages en arrière-plan
    FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);

    // Demander la permission pour les notifications sur iOS
    await FirebaseMessaging.instance.requestPermission();
  }
}
