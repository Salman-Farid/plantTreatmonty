import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController _textController = TextEditingController();
  File? _image;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
  User? _user;

  @override
  void initState() {
    super.initState();
    userStream.listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    if (_textController.text.trim().isEmpty && _image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter text or select an image')),
      );
      return;
    }

    String? imageUrl;
    if (_image != null) {
      final ref = _storage.ref().child('posts/${DateTime.now().toIso8601String()}');
      await ref.putFile(_image!);
      imageUrl = await ref.getDownloadURL();
    }

    await _firestore.collection('posts').add({
      'userId': _user?.uid,
      'userName': _user?.displayName ?? 'Anonymous',
      'text': _textController.text.trim(),
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });

    _textController.clear();
    setState(() {
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text('Community Posts'),
        backgroundColor: Colors.white, // Set app bar color to white
        elevation: 0, // Remove shadow
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Share your thoughts...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange), // Set border color to orange
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange), // Set enabled border color to orange
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.orange), // Set focused border color to orange
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 10),
                if (_image != null)
                  Image.file(_image!, height: 100, width: 100, fit: BoxFit.cover),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.image, color: Colors.orange), // Set icon color to orange
                      onPressed: _pickImage,
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: _submitPost,
                      child: Text('Post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Set button background color to orange
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('posts').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index];
                    return Card(
                      color: Colors.white, // Set card background color to white
                      margin: EdgeInsets.all(8),
                      elevation: 0.5,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(post['userName'][0]),
                        ),
                        title: Text(post['userName'],  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (post['text'] != null) Text(post['text']),
                            if (post['imageUrl'] != null)
                              Image.network(post['imageUrl'], width: 100, height: 100),
                          ],
                        ),
                        trailing: Text(DateFormat('MMM d, y • h:mm a').format(post['timestamp'].toDate())),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}