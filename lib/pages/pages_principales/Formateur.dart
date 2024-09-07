import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/pages_principales/page_chat/page_chat.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';

class Formateur extends StatefulWidget {
  const Formateur({super.key});

  @override
  State<Formateur> createState() => _FormateurState();
}

class _FormateurState extends State<Formateur> {
  final TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> filteredUserList = [];

  @override
  void initState() {
    super.initState();
    fetchUsersFromFirestore();

    searchController.addListener(() {
      filterUsers();
    });
  }

  Future<void> fetchUsersFromFirestore() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Formateur')
          .get();

      if (snapshot.docs.isEmpty) {
        print('No users found.');
      }

      final List<Map<String, dynamic>> users = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'image':
              doc['image'] ?? 'assets/images/apprenants-formateurs_logo.png',
          'userName': doc['userName'] ?? 'No name',
          'tel': doc['tel'] ?? 'No phone',
          'icon': Icons.keyboard_arrow_right,
          'backgroundColor': Colors.white,
        };
      }).toList();

      setState(() {
        userList = users;
        filteredUserList = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  void filterUsers() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      filteredUserList = userList.where((user) {
        final name = user['userName'].toLowerCase();
        final phoneNumber = user['tel'].toLowerCase();
        return name.contains(query) || phoneNumber.contains(query);
      }).toList();
    });
  }

  void _navigateToChat(String formateurId, String formateurName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          formateurId: formateurId,
          formateurName: formateurName,
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SearchContainer(
          searchController: searchController,
          hint: 'Rechercher par nom ou numéro...',
          onPress: () {},
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredUserList.length,
            itemBuilder: (context, index) {
              final user = filteredUserList[index];
              return ContainerListUser(
                user['image'],
                user['userName'],
                user['tel'],
                user['icon'],
                user['backgroundColor'],
                () => _navigateToChat(user['id'],
                    user['userName']), // Passez la fonction onPress ici
              );
            },
          ),
        ),
      ]),
    );
  }
}
