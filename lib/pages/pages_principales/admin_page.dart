import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:gestion_tickets/pages/authentification_pages/inscriprion.dart';
import 'package:gestion_tickets/pages/pages_principales/Profil.dart';
import 'package:gestion_tickets/pages/under_page/AddTickets.dart';
import 'package:gestion_tickets/pages/under_page/ReadTicket.dart';
import 'package:gestion_tickets/pages/under_page/statistics.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';
import 'package:gestion_tickets/pages/widget-pers/size_config.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot> _usersStream;
  String? _selectedUserId;
  int _bottomNavIndex = 0;
  List<Map<String, dynamic>> userList = [];
  List<Map<String, dynamic>> filteredUserList = [];
  String searchQuery = '';
  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Stream<List<DocumentSnapshot>> get _filteredUsersStream {
    if (searchQuery.isEmpty) {
      return FirebaseFirestore.instance.collection('users').snapshots().map(
            (snapshot) => snapshot.docs,
          );
    } else {
      return FirebaseFirestore.instance
          .collection('users')
          .where('userName', isGreaterThanOrEqualTo: searchQuery)
          .where('userName', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .snapshots()
          .map((snapshot) => snapshot.docs);
    }
  }

  Future<void> _addUser() async {
    await _firestore.collection('users').add({
      'userName': 'New User',
      'email': 'user@example.com',
      'role': 'Apprenant', // Vous pouvez ajuster les rôles selon vos besoins
    });
  }

//Cette methode c'est pour supprimer les utilisateurs
  Future<void> _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
  }

  Future<void> _updateUser(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  final TextEditingController searchController = TextEditingController();

  Future<void> _showUserDialog(String? userId) async {
    final isEditing = userId != null;
    final user = isEditing
        ? await _firestore.collection('users').doc(userId).get()
        : null;

    final nameController =
        TextEditingController(text: user?.data()?['userName'] ?? '');
    final emailController =
        TextEditingController(text: user?.data()?['email'] ?? '');
    final roleController =
        TextEditingController(text: user?.data()?['role'] ?? 'Apprenant');

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title:
              Text(isEditing ? 'Modifier Utilisateur' : 'Ajouter Utilisateur'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (isEditing) {
                  await _updateUser(userId!, {
                    'userName': nameController.text,
                    'email': emailController.text,
                    'role': roleController.text,
                  });
                } else {
                  await _addUser();
                }
                Navigator.of(context).pop();
              },
              child: Text(isEditing ? 'Sauvegarder' : 'Ajouter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
      // Changez ici la logique pour naviguer vers les pages appropriées
      // Par exemple, vous pourriez utiliser une page d'accueil, des statistiques, etc.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 238),
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // Ajoutez cette ligneflexibleSpace: Stack(
        backgroundColor: Colors.white,
        flexibleSpace: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Image.asset(
                  'assets/images/apprenants-formateurs_logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.black),
                onSelected: (String result) async {
                  if (result == 'logout') {
                    try {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, "/connexion");
                    } catch (e) {
                      print("Erreur lors de la déconnexion : $e");
                    }
                  }
                  if (result == 'inscription') {
                    try {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Inscription(),
                          ));
                    } catch (e) {
                      print("Erreur lors de la déconnexion : $e");
                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.logout, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Déconnexion'),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'inscription',
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.login, color: Colors.black),
                        SizedBox(width: 10),
                        Text('Inscription'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SearchContainer(
                        searchController: searchController,
                        hint: 'Rechercher',
                        onPress: () {},
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Inscription(),
                          ),
                        );
                      },
                      child: ButtomAdd(
                        const Color.fromARGB(255, 255, 192, 34),
                        Icons.person,
                        "Utilisateurs",
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: _filteredUsersStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Erreur: ${snapshot.error}'));
                    }

                    final users = snapshot.data ?? [];

                    return ListView(
                      children: users.map((user) {
                        final userId = user.id;
                        final data = user.data() as Map<String, dynamic>;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/apprenants-formateurs_logo.png'),
                              radius: 25.0,
                            ),
                            title: Text(data['userName'] ?? 'Nom'),
                            subtitle: Text(
                              'Email: ${data['email']}\nRole: ${data['role']}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                          const Text("Supprimer l'utilisateur"),
                                      content: const Text(
                                          "Êtes-vous sûr de vouloir supprimer cet utilisateur ?"),
                                      actions: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 201, 18, 5),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("Annuler",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 4, 126, 41),
                                          ),
                                          onPressed: () async {
                                            _deleteUser(userId);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Utilisateur supprimé avec succès.')),
                                            );
                                          },
                                          child: const Text("Supprimer",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            onTap: () {
                              _showUserDialog(userId);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
          // Ajoutez ici les autres pages comme les statistiques ou la page d'accueil
          Statistics(),
          const ListeTickets(),
          const Profil(),
        ],
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: const <IconData>[
          Icons.home,
          Icons.stacked_bar_chart,
          Icons.comment_rounded,
          Icons.person,
        ],
        activeIndex: _bottomNavIndex,
        onTap: _onNavItemTapped,
        backgroundColor: const Color.fromARGB(255, 255, 192, 34),
        // duration: Duration(milliseconds: 300),
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.defaultEdge,
      ),
    );
  }
}
