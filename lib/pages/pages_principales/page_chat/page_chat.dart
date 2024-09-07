import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String formateurId;
  final String formateurName;

  const ChatPage(
      {Key? key, required this.formateurId, required this.formateurName})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final Stream<QuerySnapshot> _messageStream;

  @override
  void initState() {
    super.initState();
    _initializeMessageStream();
  }

  String getConversationId(String userId1, String userId2) {
    // Retourne un ID de conversation unique pour deux utilisateurs.
    // Cela peut être une concaténation ordonnée des IDs des utilisateurs.
    List<String> ids = [userId1, userId2];
    ids.sort(); // Assure une concaténation ordonnée
    return ids.join('_');
  }

  void _initializeMessageStream() {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      final conversationId =
          getConversationId(currentUserId, widget.formateurId);
      _messageStream = FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .orderBy('timestamp', descending: false)
          .snapshots();
    }
  }

//La Methode pour la suppression de message:
  void _deleteMessage(String messageId) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final conversationId =
          getConversationId(currentUser.uid, widget.formateurId);

      // Supprimer le message dans Firestore
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .doc(messageId) // Utiliser l'ID du message pour le supprimer
          .delete()
          .then((_) {
        print("Message supprimé");
      }).catchError((error) {
        print("Erreur lors de la suppression du message : $error");
      });
    }
  }

  void _showDeleteConfirmationDialog(String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Supprimer le message"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer ce message ?"),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 192, 34)),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text(
                "Annuler",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 233, 34, 20)),
              onPressed: () {
                _deleteMessage(messageId); // Appeler la fonction de suppression
                Navigator.of(context).pop(); // Fermer la boîte de dialogue
              },
              child: const Text(
                "Supprimer",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'Timestamp not available';
    }

    final now = DateTime.now();
    final messageDate = timestamp.toDate();
    final difference = now.difference(messageDate);

    if (difference.inDays == 0) {
      return DateFormat('HH:mm').format(messageDate); // Today
    } else if (difference.inDays == 1) {
      return 'Hier à ${DateFormat('HH:mm').format(messageDate)}'; // Yesterday
    } else if (difference.inDays <= 7) {
      return DateFormat('EEEE à HH:mm').format(messageDate); // This week
    } else {
      return DateFormat('d MMMM yyyy à HH:mm')
          .format(messageDate); // Older than a week
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 251, 238),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Container(
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
                  width: 45, // Ajustez la largeur et la hauteur si nécessaire
                  height: 45,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 160,
              child: Text(
                'Chat avec ${widget.formateurName}',
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.video_camera_back_rounded),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.call),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messageStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Aucun message encore.'));
                }

                final messages = snapshot.data!.docs;
                String? previousDate;

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message['senderId'] ==
                        FirebaseAuth.instance.currentUser?.uid;
                    final Timestamp? timestamp =
                        message['timestamp'] as Timestamp?;

                    // Vérification que le timestamp n'est pas null
                    final DateTime? messageDate =
                        timestamp != null ? timestamp.toDate() : null;

                    // Si c'est le premier message ou que la date a changé, on affiche un séparateur
                    bool shouldShowDateSeparator = false;
                    if (index == 0) {
                      shouldShowDateSeparator = true;
                    } else {
                      final previousMessageDate =
                          (messages[index - 1]['timestamp'] as Timestamp?)
                              ?.toDate();
                      if (previousMessageDate != null && messageDate != null) {
                        shouldShowDateSeparator = messageDate.day !=
                                previousMessageDate.day ||
                            messageDate.month != previousMessageDate.month ||
                            messageDate.year != previousMessageDate.year;
                      }
                    }

                    return Column(
                      children: [
                        // Si la date change et que le messageDate n'est pas null, afficher un séparateur avec la date
                        if (shouldShowDateSeparator && messageDate != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              DateFormat('d MMMM yyyy').format(messageDate),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ListTile(
                          title: Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: GestureDetector(
                              onLongPress: () {
                                _showDeleteConfirmationDialog(message.id);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? const Color.fromARGB(255, 255, 192, 34)
                                      : Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message['message'] ?? '',
                                      style: TextStyle(
                                        color:
                                            isMe ? Colors.black : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      timestamp != null
                                          ? formatTimestamp(timestamp)
                                          : 'Envoi en cours...',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Envoyer un message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && _messageController.text.isNotEmpty) {
      final conversationId =
          getConversationId(currentUser.uid, widget.formateurId);
      await FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .collection('messages')
          .add({
        'senderId': currentUser.uid,
        'receiverId': widget.formateurId,
        'message': _messageController.text,
        'timestamp':
            FieldValue.serverTimestamp(), // This ensures a timestamp is set
      });

      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }
}
