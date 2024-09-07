import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/under_page/AddTickets.dart';
import 'package:gestion_tickets/pages/under_page/ReadTicket.dart';
import 'package:gestion_tickets/pages/widget-pers/buttomPers.dart';
import 'package:gestion_tickets/pages/widget-pers/size_config.dart'; // Ajoutez cette ligne pour utiliser la classe Color

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: EdgeInsets.only(top: 30, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Accueil",
                style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 7, 6, 6),
                    fontWeight: FontWeight.w700),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddTickets(),
                      ));
                },
                child: ButtomAdd(const Color.fromARGB(255, 255, 192, 34),
                    Icons.add, "Tickets"),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: AppSizes.blockSizeVertical * 5),
          width: double.infinity,
          height: AppSizes.blockSizeVertical * 30,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
                spreadRadius: 2, // Rayon d'expansion
                blurRadius: 5, // Rayon de flou
                offset: const Offset(0, 4), // Décalage de l'ombre
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            child: Image.asset(
              "assets/images/accueil-app-form.jpg",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: AppSizes.blockSizeVertical * 3,
          child: const Text(
            "Liste des ticktes",
            style: TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListeTickets(),
                ));
          },
          child: ButtomTextIconArrow(
              Colors.white, Icons.arrow_forward_ios_outlined, "Tickets"),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Liste des notifications",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        const SizedBox(
          height: 20,
        ),
        ButtomTextIconArrow(
            Colors.white, Icons.arrow_forward_ios_outlined, "Notifications"),
        const SizedBox(
          height: 20,
        ),
      ]),
    );
  }
}
