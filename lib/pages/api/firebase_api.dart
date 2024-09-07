import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    // Demande de permissions pour les notifications
    await _firebaseMessaging.requestPermission();

    // Récupération du token FCM
    final fCMToken = await _firebaseMessaging.getToken();
    print("Token: $fCMToken");

    // Affichage du token pour débogage
    if (fCMToken != null) {
      // Remplacez ceci par la méthode de journalisation de votre choix
      print("FCM Token: $fCMToken");
      // Vous pouvez également utiliser ce token pour des opérations comme envoyer au backend.
    }

    // Configurez la gestion des messages en arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Ici, vous pouvez traiter le message en arrière-plan, afficher une notification, etc.
}
