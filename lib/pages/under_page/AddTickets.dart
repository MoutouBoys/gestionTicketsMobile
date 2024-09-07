import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_tickets/pages/under_page/ReadTicket.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class AddTickets extends StatefulWidget {
  const AddTickets({super.key});

  @override
  State<AddTickets> createState() => _AddTicketsState();
}

class _AddTicketsState extends State<AddTickets> {
  final TextEditingController _ticketsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategorie;
  String? _selectedPriorite;

  // Méthode pour ajouter un ticket dans Firestore
  Future<void> _addTicket() async {
    try {
      // Récupérer l'utilisateur connecté
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        // Si l'utilisateur n'est pas connecté, afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Utilisateur non connecté'),
          ),
        );
        return;
      }

      // Récupérer le rôle de l'utilisateur depuis Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      String role = userDoc['role'];

      if (role == 'Apprenant') {
        // Ajouter le ticket dans Firestore
        await FirebaseFirestore.instance.collection('tickets').add({
          'titre': _ticketsController.text.trim(),
          'description': _descriptionController.text.trim(),
          'categorie': _selectedCategorie,
          'priorite': _selectedPriorite,
          'etat': "Attente",
          'formateurId': "",
          'userId': user.uid,
          'date': Timestamp.now(),
        });

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Ticket ajouté avec succès'),
          ),
        );

        // Réinitialiser les champs
        _ticketsController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedCategorie = null;
          _selectedPriorite = null;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ListeTickets(),
              ));
        });
      } else {
        // Afficher un message d'erreur si l'utilisateur n'est pas un apprenant
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content:
                Text("Vous n'avez pas la permission d'ajouter des tickets"),
          ),
        );
      }
    } catch (e) {
      // Afficher un message d'erreur en cas de problème
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erreur : ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            const Align(
              alignment: Alignment.center,
              child: Text(
                "Formulaire d’ajout de tickets",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              margin: const EdgeInsets.only(top: 20),
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
                    colorBar: const Color.fromARGB(255, 255, 192, 34),
                    colorIcon: const Color.fromARGB(255, 255, 192, 34),
                    controller: _ticketsController,
                    label: "Titre du Ticket : ",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                    hintText: "Entrez le titre",
                  ),
                  CustomInputField(
                    colorBar: const Color.fromARGB(255, 255, 192, 34),
                    colorIcon: const Color.fromARGB(255, 255, 192, 34),
                    controller: _descriptionController,
                    label: "Description :",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    hintText: "Entrez la description",
                  ),
                  CustomDropdownField(
                      colorBar: const Color.fromARGB(255, 255, 192, 34),
                      colorPrefix: const Color.fromARGB(255, 255, 192, 34),
                      label: "Catégorie",
                      prefixIcon: Icons.select_all_sharp,
                      items: const [
                        "Technique",
                        "Pratique",
                        "Théorique",
                      ],
                      selectedItem: _selectedCategorie,
                      onChanged: ((newValue) {
                        setState(() {
                          _selectedCategorie = newValue;
                        });
                      })),
                  CustomDropdownField(
                      colorBar: const Color.fromARGB(255, 255, 192, 34),
                      colorPrefix: const Color.fromARGB(255, 255, 192, 34),
                      label: "Priorité",
                      prefixIcon: Icons.select_all_sharp,
                      items: const [
                        "Haute",
                        "Moyen",
                        "Faible",
                      ],
                      selectedItem: _selectedPriorite,
                      onChanged: ((newValue) {
                        setState(() {
                          _selectedPriorite = newValue;
                        });
                      })),
                  CustomElevatedButton(
                    buttonText: "Ajouter Ticket",
                    onPressed: _addTicket,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
