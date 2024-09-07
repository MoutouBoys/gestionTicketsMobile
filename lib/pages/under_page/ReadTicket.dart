import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_tickets/pages/under_page/ReadAnswerTicket.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class ListeTickets extends StatefulWidget {
  const ListeTickets({super.key});

  @override
  State<ListeTickets> createState() => _ListeTicketsState();
}

class _ListeTicketsState extends State<ListeTickets> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Ajoute un listener pour reconstruire l'UI lorsqu'une recherche est effectuée
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 238),
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        margin: const EdgeInsets.only(
          top: 20,
          left: 10,
          right: 10,
        ),
        padding: const EdgeInsets.only(
          bottom: 10,
        ),
        child: Column(
          children: [
            // Widget de recherche
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Rechercher',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadAnswerTickets(),
                        ));
                  },
                  child: ButtomAdd(const Color.fromARGB(255, 255, 192, 34),
                      Icons.assignment, "Réponses"),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tickets')
                    .snapshots(), // Écoute les changements en temps réel
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Récupération des données depuis le snapshot
                  final List<QueryDocumentSnapshot> documents =
                      snapshot.data!.docs;

                  // Filtrer les tickets en fonction de la recherche
                  final query = searchController.text
                      .trim()
                      .toLowerCase(); // Requête de recherche

                  final filteredTicketsList = documents.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final titre = data['titre']?.toLowerCase() ?? '';
                    final categorie = data['categorie']?.toLowerCase() ?? '';

                    return titre.contains(query) || categorie.contains(query);
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredTicketsList.length,
                    itemBuilder: (context, index) {
                      final ticketData = filteredTicketsList[index].data()
                          as Map<String, dynamic>;

                      return ListTicket(
                        id: filteredTicketsList[index]
                            .id, // Ajoutez l'ID du document
                        titre: ticketData["titre"],
                        description: ticketData["description"],
                        categorie: ticketData["categorie"],
                        priorite: ticketData["priorite"],
                        etat: ticketData["etat"],
                        date: (ticketData["date"] as Timestamp)
                            .toDate()
                            .toString(), // Convertir le Timestamp en String
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
