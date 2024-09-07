import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  // Création de plusieurs TextEditingController pour chaque champ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  // String? _selectedRole;
  String? _profileImageUrl;
  String? _userId;
  @override
  void dispose() {
    // Libération des ressources des controllers lorsqu'ils ne sont plus nécessaires
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      _userId = user.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> data =
            userDoc.data() as Map<String, dynamic>; // Cast to Map

        setState(() {
          _nameController.text = data['userName'] ?? '';
          _emailController.text = data['email'] ?? '';
          _phoneController.text = data['tel'] ?? '';
          _profileImageUrl = data['image'] ?? '';
        });
      }
    }
  }

  void _submitForm() async {
    final name = _nameController.text;
    final phone = _phoneController.text;
    final email =
        _emailController.text; // Utilisez la valeur textuelle du contrôleur

    if (_userId != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .update({
          'userName': name,
          'tel': phone,
          'image': _profileImageUrl,
          'email': email, // Utilisez la valeur textuelle du contrôleur
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Profil mis à jour avec succès'),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Erreur lors de la mise à jour du profil: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 50),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
                      spreadRadius: 2, // Taille de l'ombre
                      blurRadius: 4, // Flou de l'ombre
                      offset: const Offset(
                          0, 3), // Décalage horizontal et vertical de l'ombre
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/accueil-app-form.jpg",
                    width:
                        200, // Ajustez la largeur et la hauteur si nécessaire
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  CustomInputField(
                    controller: _nameController,
                    colorBar: const Color.fromARGB(255, 255, 192, 34),
                    colorIcon: const Color.fromARGB(255, 255, 192, 34),
                    label: "Nom Complet : ",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                    hintText: "Entrez le nom complet",
                  ),
                  CustomInputField(
                    controller: _emailController,
                    colorBar: const Color.fromARGB(255, 255, 192, 34),
                    colorIcon: const Color.fromARGB(255, 255, 192, 34),
                    label: "Email : ",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    hintText: "Entrez l'email",
                    readOnly: true,
                  ),
                  // CustomInputField(
                  //   controller: _passwordController,
                  //   label: "Mot de passe : ",
                  //   keyboardType: TextInputType.visiblePassword,
                  //   prefixIcon: Icons.password_sharp,
                  //   hintText: "Exemple: My@92083943",
                  // ),
                  CustomInputField(
                    colorBar: const Color.fromARGB(255, 255, 192, 34),
                    colorIcon: const Color.fromARGB(255, 255, 192, 34),
                    controller: _phoneController,
                    label: "Téléphone : ",
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    hintText: "Entrez numéro tel",
                  ),
                  const ImagePickerField(
                    label: "Photo de profil : ",
                    prefixIcon: Icons.image,
                  ),
                  CustomElevatedButton(
                      buttonText: "Modifier Profil", onPressed: _submitForm)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
