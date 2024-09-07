import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class ReadAnswerTickets extends StatefulWidget {
  const ReadAnswerTickets({super.key});

  @override
  State<ReadAnswerTickets> createState() => _ReadAnswerTicketsState();
}

class _ReadAnswerTicketsState extends State<ReadAnswerTickets> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<bool> isFormateur() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = userData.data()?['role'] ?? '';
      return role == 'Formateur';
    }
    return false;
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
          child: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Rechercher',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('tickets')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tickets = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, ticketIndex) {
                      final ticketId = tickets[ticketIndex].id;
                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('tickets')
                            .doc(ticketId)
                            .collection('reponses')
                            .snapshots(), // Utilisation de snapshots() pour obtenir les mises à jour en temps réel
                        builder: (context, responseSnapshot) {
                          if (responseSnapshot.hasError) {
                            return Center(
                                child:
                                    Text('Erreur : ${responseSnapshot.error}'));
                          }

                          if (responseSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final responses = responseSnapshot.data?.docs ?? [];

                          final query =
                              searchController.text.trim().toLowerCase();
                          final filteredResponsesList = responses.where((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final titre = data['titre']?.toLowerCase() ?? '';
                            final description =
                                data['description']?.toLowerCase() ?? '';

                            return titre.contains(query) ||
                                description.contains(query);
                          }).toList();

                          return Column(
                            children: filteredResponsesList.map((doc) {
                              final responseData =
                                  doc.data() as Map<String, dynamic>;

                              return ListAnswerTickets(
                                ticketId:
                                    ticketId, // Assurez-vous que vous passez ticketId
                                responseId: doc.id,
                                titre: responseData["titre"],
                                description: responseData["description"],
                                date: (responseData["date"] as Timestamp)
                                    .toDate()
                                    .toString(),
                                isFormateurFuture:
                                    isFormateur(), // Passer directement le Future<bool>
                              );
                            }).toList(),
                          );
                        },
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
