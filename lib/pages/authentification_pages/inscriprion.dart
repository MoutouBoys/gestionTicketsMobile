import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/authentification_pages/connexion.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class Inscription extends StatefulWidget {
  const Inscription({Key? key}) : super(key: key);

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  @override
  void initState() {
    super.initState();

    // Gérer la mise à jour du token FCM en temps réel
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _updateUserFCMToken(newToken);
    });
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  String? roleController;

  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  @override
  void dispose() {
    // TODO: implement dispose
    userNameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    roleController;
    telController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Vérifiez d'abord le rôle de l'utilisateur connecté
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content:
              Text('Vous devez être connecté pour effectuer cette action.'),
        ),
      );
      return;
    }

    // Récupérez les informations de l'utilisateur connecté depuis Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();

    // Vérifiez si l'utilisateur a le rôle Administrateur
    final userRole = userDoc.get('role');
    if (userRole != 'Administrateur') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
              'Vous n\'avez pas les droits nécessaires pour ajouter un nouvel utilisateur.'),
        ),
      );
      return;
    }

    // Si l'utilisateur a le rôle Administrateur, procédez à l'inscription
    if (_formKey.currentState?.validate() ?? false) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        // Mise à jour du profil utilisateur
        await userCredential.user
            ?.updateDisplayName(userNameController.text.trim());

        // Ajout de l'utilisateur dans Firestore avec rôle
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'email': emailController.text.trim(),
          'userName': userNameController.text.trim(),
          'tel': telController.text.trim(),
          'role':
              roleController, // Assurez-vous que 'roleController' est un TextEditingController
          'AdministrateurId': currentUser
              .uid, // Ajoutez l'ID de l'administrateur qui effectue l'enregistrement
          "image": "assets/images/apprenants-formateurs_logo.png",
        });

        // Envoyer une notification dans Firestore
        // await FirebaseFirestore.instance.collection('notifications').add({
        //   'title': 'Nouvel utilisateur inscrit',
        //   'message':
        //       'Un nouvel utilisateur a été inscrit avec l\'email ${emailController.text.trim()}',
        //   'timestamp': FieldValue.serverTimestamp(), // Ajoutez un horodatage
        // });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Inscription réussie'),
          ),
        );
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'weak-password') {
          message = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          message = 'Un compte avec cet email existe déjà.';
        } else {
          message = 'Une erreur est survenue lors de l\'inscription.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(message),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Une erreur s\'est produite. Veuillez réessayer.'),
          ),
        );
      }
    }
  }

//Pour la messagerie
  Future<void> _saveFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print('Token FCM: $token');
      await _updateUserFCMToken(token);
    }
  }

  Future<void> _updateUserFCMToken(String token) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fcmToken': token,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/inscription.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                          "assets/images/apprenants-formateurs_logo.png"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                            size: 35,
                          ),
                          onSelected: (String result) async {
                            if (result == 'logout') {
                              try {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacementNamed(
                                    context, "/connexion");
                              } catch (e) {
                                print("Erreur lors de la déconnexion : $e");
                              }
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'logout',
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.logout, color: Colors.black),
                                  SizedBox(width: 10),
                                  Text('Déconnexion'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Spacer(),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Connectez-vous",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomInputField(
                              controller: userNameController,
                              prefixIcon: Icons.email,
                              colorBar: const Color.fromARGB(255, 255, 192, 34),
                              colorIcon:
                                  const Color.fromARGB(255, 255, 192, 34),
                              hintText: "Nom complet",
                              keyboardType: TextInputType.name,
                            ),
                            const SizedBox(height: 10),
                            CustomInputField(
                              controller: emailController,
                              prefixIcon: Icons.email,
                              colorBar: const Color.fromARGB(255, 255, 192, 34),
                              colorIcon:
                                  const Color.fromARGB(255, 255, 192, 34),
                              hintText: "Entrez votre email",
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 10),
                            CustomInputField(
                              controller: telController,
                              prefixIcon: Icons.call,
                              colorBar: const Color.fromARGB(255, 255, 192, 34),
                              colorIcon:
                                  const Color.fromARGB(255, 255, 192, 34),
                              hintText: "Téléphone",
                              keyboardType: TextInputType.phone,
                            ),
                            const SizedBox(height: 10),
                            CustomInputFieldPassword(
                              controller: passwordController,
                              prefixIcon: Icons.lock,
                              colorBar: const Color.fromARGB(255, 255, 192, 34),
                              colorIcon: Colors.black,
                              hintText: "Entrez votre mot de passe",
                              obscureText: _obscureText,
                              prefixColorIcon:
                                  const Color.fromARGB(255, 255, 192, 34),
                            ),
                            const SizedBox(height: 10),
                            CustomDropdownField(
                                colorPrefix:
                                    const Color.fromARGB(255, 255, 192, 34),
                                prefixIcon: Icons.select_all_sharp,
                                selectedItem: roleController,
                                items: const [
                                  "Apprenant",
                                  "Formateur",
                                  "Administrateur",
                                ],
                                onChanged: ((newValue) {
                                  setState(() {
                                    roleController = newValue;
                                  });
                                })),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isChecked = value ?? false;
                                        });
                                      },
                                    ),
                                    const Text(
                                      'Souvenez-vous de moi',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Action pour "Mot de passe oublié ?"
                                  },
                                  child: const Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _register();
                                }
                              },
                              //() {
                              // if (_formKey.currentState?.validate() ?? false) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(
                              //         backgroundColor:
                              //             Color.fromARGB(255, 255, 192, 34),
                              //         content: Text('Formulaire validé')),
                              //   );
                              // }
                              // },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 255, 192, 34),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 120),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                "Inscription",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Vous avez déjà un compte ? ',
                    style: const TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Se connecter',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 192, 34),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Action pour le tap sur "S’enregistrer"
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => const Connexion(),
                            //     ));
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
