import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gestion_tickets/pages/authentification_pages/connexion.dart';
import 'package:gestion_tickets/pages/authentification_pages/inscriprion.dart';
import 'package:gestion_tickets/pages/widget-pers/bottom_nav_btn.dart';
import 'package:gestion_tickets/pages/widget-pers/clipper.dart';
import 'package:gestion_tickets/pages/widget-pers/constants.dart';
import 'package:gestion_tickets/pages/widget-pers/size_config.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: const Duration(
        milliseconds: 400,
      ),
      curve: Curves.decelerate,
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 238),
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading:
            false, // Ajoutez cette ligneflexibleSpace: Stack(

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
                  // if (result == 'inscription') {
                  //   try {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => const Inscription(),
                  //         ));
                  //   } catch (e) {
                  //     print("Erreur lors de la déconnexion : $e");
                  //   }
                  // }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
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
                  // PopupMenuItem<String>(
                  //   value: 'inscription',
                  //   child: Row(
                  //     children: <Widget>[
                  //       Icon(Icons.login, color: Colors.black),
                  //       SizedBox(width: 10),
                  //       Text('Inscription'),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
                child: PageView(
              onPageChanged: (value) {
                setState(() {
                  _currentIndex = value;
                });
              },
              controller: pageController,
              children: screens,
            )),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: bottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomNav() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSizes.blockSizeHorizontal * 4.5,
        0,
        AppSizes.blockSizeHorizontal * 4.5,
        10,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        elevation: 6,
        child: Container(
            height: AppSizes.blockSizeHorizontal * 8,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
                  spreadRadius: 2, // Rayon d'expansion
                  blurRadius: 5, // Rayon de flou
                  offset: const Offset(0, 4), // Décalage de l'ombre
                ),
              ],
              color: Colors
                  .white, // Changez cette ligne pour définir la couleur de fond du footer
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: AppSizes.blockSizeHorizontal * 3,
                  right: AppSizes.blockSizeHorizontal * 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);
                          setState(() {
                            _currentIndex = val;
                          });
                        },
                        icon: Icons.home,
                        currentIndex: _currentIndex,
                        index: 0,
                      ),
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);

                          setState(() {
                            _currentIndex = val;
                          });
                        },
                        icon: Icons.school,
                        currentIndex: _currentIndex,
                        index: 1,
                      ),
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);

                          setState(() {
                            _currentIndex = val;
                          });
                        },
                        icon: Icons.menu_book,
                        currentIndex: _currentIndex,
                        index: 2,
                      ),
                      BottomNavBTN(
                        onPressed: (val) {
                          animateToPage(val);

                          setState(() {
                            _currentIndex = val;
                          });
                        },
                        icon: Icons.person,
                        currentIndex: _currentIndex,
                        index: 3,
                      ),
                    ],
                  ),
                ),
                AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.decelerate,
                    top: 0,
                    left: animatedPositionedLEftValue(_currentIndex),
                    child: Column(
                      children: [
                        Container(
                          height: AppSizes.blockSizeHorizontal * 1.0,
                          width: AppSizes.blockSizeHorizontal * 12,
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        ClipPath(
                          clipper: MyCustomClipper(),
                          child: Container(
                            height: AppSizes.blockSizeHorizontal * 15,
                            width: AppSizes.blockSizeHorizontal * 12,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: gradient,
                            )),
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );
  }
}
