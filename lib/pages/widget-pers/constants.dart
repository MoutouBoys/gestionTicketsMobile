import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/pages_principales/Accueil.dart';
import 'package:gestion_tickets/pages/pages_principales/Apprenant.dart';
import 'package:gestion_tickets/pages/pages_principales/Formateur.dart';
import 'package:gestion_tickets/pages/pages_principales/Profil.dart';
import 'package:gestion_tickets/pages/widget-pers/size_config.dart';

List<Widget> screens = [
  const Accueil(),
  const Apprenant(),
  const Formateur(),
  const Profil(),
  // const SampleWidget(
  //   label: 'PROFILE',
  //   color: Colors.redAccent,
  // ),
];

double animatedPositionedLEftValue(int currentIndex) {
  switch (currentIndex) {
    case 0:
      return AppSizes.blockSizeHorizontal * 7.4;
    case 1:
      return AppSizes.blockSizeHorizontal * 28.8;
    case 2:
      return AppSizes.blockSizeHorizontal * 50;
    case 3:
      return AppSizes.blockSizeHorizontal * 71.4;
    // case 4:
    //   return AppSizes.blockSizeHorizontal * 73.5;
    default:
      return 0;
  }
}

final List<Color> gradient = [
  const Color.fromARGB(255, 255, 192, 34).withOpacity(0.8),
  const Color.fromARGB(255, 255, 192, 34).withOpacity(0.5),
  Colors.transparent
];
