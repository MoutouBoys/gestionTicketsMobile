import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gestion_tickets/pages/under_page/AddTickets.dart';
import 'package:gestion_tickets/pages/under_page/ReadAnswerTicket.dart';
import 'package:gestion_tickets/pages/under_page/ReadTicket.dart';
import 'package:gestion_tickets/pages/under_page/RepondreTicket.dart';
import 'package:gestion_tickets/pages/widget-pers/size_config.dart';
import 'dart:io' as io; //importation pour le mobiel

import 'package:image_picker/image_picker.dart'; // Renommez l'import pour éviter les conflits

Widget ButtomAdd(Color color1, IconData icon, String text) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: AppSizes.blockSizeHorizontal * 2.5,
        vertical: AppSizes.blockSizeVertical * 1),
    decoration: BoxDecoration(
        color: color1, borderRadius: BorderRadius.all(Radius.circular(10))),
    child: Row(
      children: [
        Icon(
          icon,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(text)
      ],
    ),
  );
}

Widget ButtomTextIconArrow(Color color1, IconData icon, String text) {
  return Container(
    padding: EdgeInsets.symmetric(
        horizontal: AppSizes.blockSizeHorizontal * 2.5,
        vertical: AppSizes.blockSizeVertical * 1),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
            spreadRadius: 2, // Rayon d'expansion
            blurRadius: 5, // Rayon de flou
            offset: const Offset(0, 4), // Décalage de l'ombre
          ),
        ],
        color: color1,
        borderRadius: const BorderRadius.all(Radius.circular(10))),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(text), Icon(icon)],
    ),
  );
}

class SearchContainer extends StatelessWidget {
  final TextEditingController searchController;
  final String? hint;
  final VoidCallback? onPress;
  const SearchContainer(
      {Key? key, required this.searchController, this.hint, this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 30),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          icon: Icon(Icons.search, color: Colors.grey),
          hintText: 'Rechercher...',
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class ContainerListUser extends StatelessWidget {
  final String imagePath;
  final String name;
  final String phoneNumber;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback? onPress;

  const ContainerListUser(
    this.imagePath,
    this.name,
    this.phoneNumber,
    this.icon,
    this.backgroundColor,
    this.onPress, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress, // Appel de la fonction onPress ici
      child: Container(
        margin: const EdgeInsets.only(bottom: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
                    spreadRadius: 2, // Rayon d'expansion
                    blurRadius: 5, // Rayon de flou
                    offset: const Offset(0, 4), // Décalage de l'ombre
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 50, // Ajustez la largeur et la hauteur si nécessaire
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(phoneNumber),
                  ],
                ),
              ),
            ),
            Icon(icon),
          ],
        ),
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final Color colorBar;
  final Color colorIcon;
  final TextInputType keyboardType;
  final bool readOnly;

  const CustomInputField({
    Key? key,
    required this.controller,
    this.label = '',
    this.hintText = '',
    this.prefixIcon = Icons.text_fields,
    this.colorBar = Colors.grey,
    this.colorIcon = Colors.grey,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 130,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: TextFormField(
                autocorrect: true,
                controller: controller,
                readOnly: readOnly,
                decoration: InputDecoration(
                  labelText: hintText.isEmpty ? label : null,
                  hintText: hintText,
                  prefixIcon: Icon(
                    prefixIcon,
                    color: colorIcon,
                  ),
                  suffixIcon: controller.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            controller.clear();
                          },
                        )
                      : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorBar),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorIcon),
                  ),
                  errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                keyboardType: keyboardType,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ce champ ne peut pas être vide';
                  }

                  if (keyboardType == TextInputType.emailAddress) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer une adresse email valide';
                    }
                  } else if (keyboardType == TextInputType.phone) {
                    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                      return 'Veuillez entrer un numéro de téléphone valide';
                    }
                  } else if (keyboardType == TextInputType.number) {
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Veuillez entrer un numéro valide';
                    }
                  } else if (keyboardType == TextInputType.url) {
                    if (!RegExp(r'^(https?|ftp)://[^\s/$.?#].[^\s]*$')
                        .hasMatch(value)) {
                      return 'Veuillez entrer une URL valide';
                    }
                  } else if (keyboardType == TextInputType.datetime) {
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Veuillez entrer une date valide (YYYY-MM-DD)';
                    }
                  } else if (keyboardType == TextInputType.visiblePassword) {
                    if (value.length < 8) {
                      return 'Le mot de passe doit contenir au moins 8 caractères';
                    }
                  } else if (keyboardType == TextInputType.text) {
                    if (value.trim().isEmpty) {
                      return 'Ce champ ne peut pas être vide';
                    }
                  }

                  return null;
                }),
          ),
        ],
      ),
    );
  }
}

class CustomInputFieldPassword extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final Color colorBar;
  final Color colorIcon;
  final Color prefixColorIcon;
  final bool obscureText;

  const CustomInputFieldPassword({
    Key? key,
    required this.controller,
    this.label = '',
    this.hintText = '',
    this.prefixIcon = Icons.text_fields,
    this.colorBar = Colors.grey,
    this.colorIcon = Colors.grey,
    this.prefixColorIcon = Colors.grey,
    this.obscureText = false,
  }) : super(key: key);

  @override
  _CustomInputFieldPasswordState createState() =>
      _CustomInputFieldPasswordState();
}

class _CustomInputFieldPasswordState extends State<CustomInputFieldPassword> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.label.isNotEmpty)
            SizedBox(
              width: 130,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: widget.hintText.isEmpty ? widget.label : null,
                hintText: widget.hintText,
                prefixIcon: Icon(
                  widget.prefixIcon,
                  color: widget.prefixColorIcon,
                ),
                suffixIcon: IconButton(
                  color: Colors.black,
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: widget.colorIcon,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.colorBar),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: widget.colorIcon),
                ),
                errorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ ne peut pas être vide';
                }

                // Validation spécifique au mot de passe
                if (value.length < 8) {
                  return 'Le mot de passe doit contenir au moins 8 caractères';
                }

                // Optionnel : Validation de la complexité du mot de passe
                // Décommentez ce bloc si vous souhaitez appliquer des exigences de complexité
                /*
                final hasUppercase = RegExp(r'[A-Z]').hasMatch(value);
                final hasDigits = RegExp(r'\d').hasMatch(value);
                final hasLowercase = RegExp(r'[a-z]').hasMatch(value);
                final hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

                if (!hasUppercase || !hasDigits || !hasLowercase || !hasSpecialCharacters) {
                  return 'Le mot de passe doit contenir des majuscules, des chiffres, des minuscules et des caractères spéciaux';
                }
                */

                return null; // Return null if no errors
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ImagePickerField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;

  const ImagePickerField({
    Key? key,
    this.label = '',
    this.prefixIcon = Icons.image,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  io.File? _imageFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = io.File(pickedFile.path); // Utilisation de `io.File`
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0, top: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: SizedBox(
                width: 130,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!, // Utilisation de `_imageFile!` avec `io.File`
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.prefixIcon, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text(
                              "Choisissez une image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Définissez un widget personnalisé pour le bouton
class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  // Constructeur pour initialiser les paramètres
  const CustomElevatedButton({
    Key? key,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(
            255, 255, 192, 34), // Couleur de fond du bouton
        shadowColor: const Color.fromARGB(
            255, 255, 192, 34), // Couleur du texte du bouton
        padding:
            const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
        textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold), // Style du texte
      ),
      child: Text(
        buttonText,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

// Pour mes champs select
class CustomDropdownField extends StatelessWidget {
  final String label;
  final IconData prefixIcon;
  final List<String> items;
  final String? selectedItem;
  final Color colorPrefix;
  final Color colorBar;
  final ValueChanged<String?> onChanged;

  const CustomDropdownField({
    Key? key,
    this.label = '',
    required this.prefixIcon,
    required this.items,
    this.selectedItem,
    this.colorPrefix = Colors.black,
    this.colorBar = Colors.black,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (label.isNotEmpty)
            SizedBox(
              width: 130,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedItem,
              icon: const Icon(Icons.arrow_drop_down),
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorBar)),
                prefixIcon: Icon(prefixIcon, color: colorPrefix),
              ),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Ce champ est obligatoire';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}

//La liste de mes tickets depuis firebase
class ListTicket extends StatefulWidget {
  final String
      id; // Ajoutez l'ID du ticket pour la mise à jourrequired this.id,
  final String titre;
  final String description;
  final String categorie;
  final String priorite;
  final String date;
  final String etat;

  const ListTicket({
    Key? key,
    required this.id,
    required this.titre,
    required this.categorie,
    required this.description,
    required this.priorite,
    required this.date,
    required this.etat,
  }) : super(key: key);

  @override
  State<ListTicket> createState() => _ListTicketState();
}

class _ListTicketState extends State<ListTicket> {
//Pour récuperer uniquent l'id du formateur
  Future<bool> isFormateur() async {
    // Récupérez les informations de l'utilisateur actuel depuis Firebase Auth ou Firestore
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

//Pour récuperer uniquent l'id de l'apprenant
  Future<bool> isApprenant() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final role = userData.data()?['role'] ?? '';
      return role == 'Apprenant';
    }
    return false;
  }

  void _showModificationDialog(BuildContext context) {
    final _titreController = TextEditingController(text: widget.titre);
    final _descriptionController =
        TextEditingController(text: widget.description);
    final _categorieController = TextEditingController(text: widget.categorie);
    final _prioriteController = TextEditingController(text: widget.priorite);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Modifier le ticket"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titreController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 193, 35),
                  )),
                  hintText: "Titre",
                  prefixIcon: Icon(
                    Icons.person,
                    color: Color.fromARGB(255, 255, 193, 35),
                  ),
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 193, 35),
                  )),
                  hintText: "Description",
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Color.fromARGB(255, 255, 193, 35),
                  ),
                ),
              ),
              TextField(
                controller: _categorieController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 193, 35),
                  )),
                  hintText: "Catégorie",
                  prefixIcon: Icon(
                    Icons.select_all,
                    color: Color.fromARGB(255, 255, 193, 35),
                  ),
                ),
              ),
              TextField(
                controller: _prioriteController,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Color.fromARGB(255, 255, 193, 35),
                  )),
                  hintText: "Priorité",
                  prefixIcon: Icon(
                    Icons.select_all,
                    color: Color.fromARGB(255, 255, 193, 35),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(
                    255, 126, 4, 4), // Couleur de fond pour "Prendre en charge"
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Annuler",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 126,
                    41), // Couleur de fond pour "Prendre en charge"
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('tickets')
                    .doc(widget.id)
                    .update({
                  'titre': _titreController.text,
                  'description': _descriptionController.text,
                  'categorie': _categorieController.text,
                  'priorite': _prioriteController.text,
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ticket modifié avec succès.')),
                );
              },
              child: const Text(
                "Modifier",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTicket(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer le ticket"),
          content: const Text("Êtes-vous sûr de vouloir supprimer ce ticket ?"),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 201, 18,
                    5), // Couleur de fond pour "Prendre en charge"
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Annuler",
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 4, 126,
                    41), // Couleur de fond pour "Prendre en charge"
              ),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('tickets')
                    .doc(widget.id)
                    .delete();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ticket supprimé avec succès.')),
                );
              },
              child: Text(
                "Supprimer",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Voulez-vous vraiment effectuer cette action ?"),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 201, 18,
                            5), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("Supprimer",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close confirmation modal
                        _deleteTicket(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 181,
                            224), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("modifier",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        Navigator.of(context).pop(); // Close confirmation modal
                        _showModificationDialog(context);
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 129,
                            4), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("Ajouter",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddTickets(),
                            )); // Ferme le modal
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 201, 18,
                            5), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("Annuler",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop(); // Ferme le modal
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 9, 181,
                            224), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("Répondre",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () async {
                        // Vérifiez si l'utilisateur est le formateur qui a pris en charge ce ticket
                        if (await _isFormateurAssignedToTicket()) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RepondreTicket(ticketId: widget.id),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Vous n\'êtes pas autorisé à répondre à ce ticket.')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 14, 129,
                            4), // Couleur de fond pour "Prendre en charge"
                      ),
                      child: const Text("Prendre en charge",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: () {
                        prendreEnChargeTicket(context);
                        Navigator.of(context).pop(); // Ferme le modal
                      },
                    )
                  ],
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<bool> _isFormateurAssignedToTicket() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ticketData = await FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.id)
          .get();
      final formateurId = ticketData.data()?['formateurId'] ?? '';
      return formateurId == user.uid;
    }
    return false;
  }

  Future<void> prendreEnChargeTicket(BuildContext context) async {
    try {
      print('Appel de prendreEnChargeTicket');
      final ticketRef =
          FirebaseFirestore.instance.collection('tickets').doc(widget.id);
      final ticketData = await ticketRef.get();

      if (ticketData.exists) {
        final etat = ticketData.data()?['etat'] ?? 'Attente';
        print('État du ticket: $etat');

        if (etat == 'En cours' || etat == 'Résolu') {
          print('Ticket déjà pris en charge');
          // Utilisez le ScaffoldMessenger avec une fonction de rappel
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ScaffoldMessenger.maybeOf(context) != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Ce ticket a déjà été pris en charge.')),
              );
            }
          });
          return;
        }

        if (await isFormateur()) {
          final user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await ticketRef.update({
              'formateurId': user.uid,
              'etat': 'En cours',
            });
            print('Ticket mis à jour');
            // Utilisez le ScaffoldMessenger avec une fonction de rappel
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (ScaffoldMessenger.maybeOf(context) != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Le ticket a été pris en charge.')),
                );
              }
            });
          }
        } else {
          print('Utilisateur non autorisé');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (ScaffoldMessenger.maybeOf(context) != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                        'Vous n\'êtes pas autorisé à prendre en charge ce ticket.')),
              );
            }
          });
        }
      }
    } catch (e) {
      // Gérer les erreurs possibles
      print('Erreur lors de la prise en charge du ticket: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(context),
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.only(
          bottom: 10,
          left: 10,
          right: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2), // Couleur de l'ombre
              spreadRadius: 2, // Rayon d'expansion
              blurRadius: 5, // Rayon de flou
              offset: const Offset(0, 4), // Décalage de l'ombre
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ligne avec le titre et l'image
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.titre,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80, // Ajustez la taille de l'image ici
                  height: 80,
                  child: Image.asset(
                    "assets/images/ticket.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              width: 320,
              child: Text(
                widget.description,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Text(
                  widget.categorie,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.priorite,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.etat,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Widget modifié pour inclure les boutons de modification et de suppression

class ListAnswerTickets extends StatefulWidget {
  final String ticketId; // Identifiant du ticket
  final String responseId; // Identifiant de la réponse
  final String titre;
  final String description;
  final String date;
  final Future<bool> isFormateurFuture;

  const ListAnswerTickets({
    super.key,
    required this.ticketId,
    required this.responseId,
    required this.titre,
    required this.description,
    required this.date,
    required this.isFormateurFuture,
  });

  @override
  State<ListAnswerTickets> createState() => _ListAnswerTicketsState();
}

class _ListAnswerTicketsState extends State<ListAnswerTickets> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: widget.isFormateurFuture,
      builder: (context, snapshot) {
        final isFormateur = snapshot.data ?? false;

        return GestureDetector(
          onTap: () {
            if (isFormateur) {
              _showActionModal(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Seuls les formateurs peuvent effectuer cette action.'),
                ),
              );
            }
          },
          child: Container(
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.titre,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: Image.asset(
                        "assets/images/answer_tickets.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: 320,
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(width: 15),
                Text(
                  widget.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showActionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Modifier'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditModal(context);
                },
              ),
              ListTile(
                // titleTextStyle:
                //     TextStyle(color: Colors.white, backgroundColor: Colors.red),
                leading: const Icon(Icons.delete),
                title: const Text('Supprimer'),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteTicket(context);
                },
              ),
              ListTile(
                // titleTextStyle: TextStyle(
                //     color: Colors.white,
                //     backgroundColor: const Color.fromARGB(255, 10, 153, 219)),
                leading: const Icon(Icons.add),
                title: const Text('Ajouter'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListeTickets(),
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditModal(BuildContext context) {
    // Affiche le modal de modification
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController titreController =
            TextEditingController(text: widget.titre);
        final TextEditingController descriptionController =
            TextEditingController(text: widget.description);

        return AlertDialog(
          title: const Text('Modifier la Réponse'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titreController,
                decoration: const InputDecoration(labelText: 'Titre'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 9, 127, 224)),
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('tickets')
                      .doc(widget.ticketId)
                      .collection('reponses')
                      .doc(widget.responseId)
                      .update({
                    'titre': titreController.text,
                    'description': descriptionController.text,
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Réponse modifiée.')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur : $e')),
                  );
                }
              },
              child: const Text(
                'Modifier',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 224, 9, 9)),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteTicket(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(widget.ticketId)
          .collection('reponses')
          .doc(widget.responseId)
          .delete();

      // Vérifiez si le widget est toujours monté avant d'utiliser le contexte
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Réponse supprimée.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }
}


/*import 'dart:html'; // Import pour le web

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;

  const ImagePickerField({
    Key? key,
    this.label = '',
    this.prefixIcon = Icons.image,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsFile();

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.prefixIcon, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text(
                              "Choisissez une image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  import 'dart:html'; // Import pour le web

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

class ImagePickerField extends StatefulWidget {
  final String label;
  final IconData prefixIcon;

  const ImagePickerField({
    Key? key,
    this.label = '',
    this.prefixIcon = Icons.image,
  }) : super(key: key);

  @override
  _ImagePickerFieldState createState() => _ImagePickerFieldState();
}

class _ImagePickerFieldState extends State<ImagePickerField> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePickerWeb.getImageAsFile();

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.label.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          Expanded(
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          _imageFile!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(widget.prefixIcon, color: Colors.grey),
                            const SizedBox(width: 8),
                            const Text(
                              "Choisissez une image",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}*/
