import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/MyHomePage.dart';
import 'package:gestion_tickets/pages/authentification_pages/connexion.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDcpJlVuqp9ZDUtjHN5YZ6STxKcxyg5JYE",
      authDomain: "gestion-de-tickets-ef5db.firebaseapp.com",
      projectId: "gestion-de-tickets-ef5db",
      storageBucket: "gestion-de-tickets-ef5db.appspot.com",
      messagingSenderId: "35922709972",
      appId: "1:35922709972:web:1ad6c4f89445b0052d1a41",
      measurementId: "G-68LN41FNPB",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: AuthCheck(),
      routes: {
        '/connexion': (context) => Connexion(),
        '/home': (context) => MyHomePage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisez un StreamBuilder pour écouter les changements d'état de connexion
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Affichez un indicateur de chargement pendant la vérification
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        // Vérifiez si l'utilisateur est connecté
        if (snapshot.hasData && snapshot.data != null) {
          return MyHomePage(); // Utilisateur connecté, redirige vers la page d'accueil
        } else {
          return Connexion(); // Utilisateur non connecté, redirige vers la page de connexion
        }
      },
    );
  }
}


// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasData) {
//           return MyHomePage();
//         } else {
//           return Connexion();
//         }
//       },
//     );
//   }
// }
