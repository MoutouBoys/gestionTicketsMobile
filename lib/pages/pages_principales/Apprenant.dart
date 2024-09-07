import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';
import 'package:gestion_tickets/pages/pages_principales/page_chat/page_chat.dart';

class Apprenant extends StatefulWidget {
  const Apprenant({super.key});

  @override
  State<Apprenant> createState() => _ApprenantState();
}

class _ApprenantState extends State<Apprenant> {
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
          .where('role', isEqualTo: 'Apprenant')
          .get();

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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SearchContainer(
          searchController: searchController,
          hint: 'Rechercher',
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
                () => _navigateToChat(user['id'], user['userName']),
              );
            },
          ),
        ),
      ]),
    );
  }
}
