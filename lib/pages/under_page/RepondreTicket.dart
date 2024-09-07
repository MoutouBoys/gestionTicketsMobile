import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class RepondreTicket extends StatefulWidget {
  final String ticketId; // Ajoutez cette ligne pour recevoir l'ID du ticket
  const RepondreTicket({super.key, required this.ticketId});

  @override
  State<RepondreTicket> createState() => _RepondreTicketState();
}

class _RepondreTicketState extends State<RepondreTicket> {
  final TextEditingController _ticketsController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedPertinence;

  Future<void> _addAnswerTicket() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.ticketId)
          .collection('reponses')
          .add({
        'titre': _ticketsController.text,
        'description': _descriptionController.text,
        'pertinence': _selectedPertinence,
        'formateurId': user.uid,
        'date': DateTime.now(),
      });
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.ticketId)
          .update({
        'etat': "Résolu",
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Votre réponse a été ajoutée.')),
      );

      Navigator.pop(context); // Ferme la page de réponse
    }
  }

  @override
  void dispose() {
    _ticketsController.dispose();
    _descriptionController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
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
                "Formulaire de réponse aux tickets",
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
                    controller: _ticketsController,
                    label: "Titre du Ticket : ",
                    keyboardType: TextInputType.text,
                    prefixIcon: Icons.person,
                    hintText: "Entrez le titre",
                  ),
                  CustomInputField(
                    controller: _descriptionController,
                    label: "Description :",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    hintText: "Entrez la description",
                  ),
                  CustomDropdownField(
                      label: "Priorité",
                      prefixIcon: Icons.select_all_sharp,
                      items: const [
                        "Haute",
                        "Moyen",
                        "Faible",
                      ],
                      selectedItem: _selectedPertinence,
                      onChanged: ((newValue) {
                        setState(() {
                          _selectedPertinence = newValue;
                        });
                      })),
                  CustomElevatedButton(
                    buttonText: "Répondre Ticket",
                    onPressed: _addAnswerTicket,
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
