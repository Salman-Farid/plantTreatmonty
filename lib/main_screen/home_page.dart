import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:http/http.dart' as http;
import 'package:plant_treatmonty/services/auth_service.dart';
import 'package:plant_treatmonty/widgets/drawer_header.dart';
import 'package:plant_treatmonty/widgets/quick_action_button_widget.dart';
import '../Disease_library_and_plant_care_tips/DiseaseLibraryPage.dart';
import '../Disease_library_and_plant_care_tips/PlantCarePage.dart';
import '../auth_screens/login_page.dart';
import '../analysis_image_page.dart';
import '../feedback_page.dart';

// Color scheme
const softGreen = Color(0xFF28A745); // Clean and fresh green
const softBlue = Color(0xFF007BFF); // Clean and fresh blue
const softOrange = Color(0xFFFFA500); // Clean and fresh orange

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final AuthService _authService = AuthService();

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Stream<User?> userStream = FirebaseAuth.instance.authStateChanges();
  User? _user;
  String? _fullName;
  Uint8List? _imageData;
  bool _isLoading = false;
  late AnimationController _animationController;
  late StreamSubscription<User?> _userSubscription;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    _userSubscription = userStream.listen((user) {
      setState(() {
        _user = user;
        if (_user != null) {
          _fetchFullName(); // Fetch full name when user is available
        }
      });
    });
  }

  Future<void> _fetchFullName() async {
    if (_user != null) {
      if (_user!.displayName != null) {
        setState(() {
          _fullName = _user!.displayName;
        });
      } else {
        DatabaseReference userRef = FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(_user!.uid);

        DataSnapshot snapshot = await userRef.get();

        if (snapshot.value != null) {
          Map<String, dynamic> userData = Map<String, dynamic>.from(snapshot.value as Map);
          setState(() {
            _fullName = userData['name'];
          });
        }
      }
    }
  }


  @override
  void dispose() {
    _animationController.dispose();
    _imageData = null;
    _userSubscription.cancel();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage == null) return;
      final imageData = await pickedImage.readAsBytes();
      setState(() {
        _imageData = imageData;
      });
    } catch (e) {
      _showErrorSnackBar('Failed to process image: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(16),
      ),
    );
  }

  Future<void> _analyzeImage() async {
    if (_imageData == null) {
      _showErrorSnackBar('Please select an image first');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uri = Uri.parse(
          'https://plant-disease-detection-2-aa5x.onrender.com/predict/');
      var request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          _imageData!,
          filename: 'plant_image.jpg',
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      print('Response Data: $responseData');
      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(responseData);
        String prediction = result['prediction'];

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AnalysisImagePage(
              imageData: _imageData!,
              prediction: prediction,
            ),
          ),
        );
      } else {
        _showErrorSnackBar('Failed to analyze image: Server error');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to analyze image: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Adjusted padding
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Adjusted border radius
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 14, // Adjusted font size
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    ).animate()
        .fadeIn(duration: 600.ms)
        .slideY(begin: 0.3, duration: 600.ms, curve: Curves.easeOut);
  }

  Widget _buildImagePreview() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      height: _imageData != null ? 200 : 0, // Adjusted height
      child: _imageData != null
          ? Hero(
        tag: 'preview_image',
        child: Container(
          margin: EdgeInsets.all(8), // Adjusted margin
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // Adjusted border radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.memory(
              _imageData!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      )
          : SizedBox.shrink(),
    ).animate().fadeIn().scale(begin: const Offset(0.8, 0.8));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Plant Disease Detection',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn().slideX(begin: -0.3, duration: 600.ms),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => LoginPage(
                      authService: _authService,
                    )),
              );
            },
          ),
        ],
      ),



      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            buildDrawerHeader(_fullName, _user),


            ListTile(
              leading: Icon(Icons.eco, color: softGreen),
              title: Text('Plant Care Guide'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PlantCarePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services, color: softOrange),
              title: Text('Disease Library'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiseaseLibraryPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback, color: Colors.blue),
              title: Text('Feedback'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackPage()),
                );
              },
            ),
          ],
        ),
      ),




      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${_fullName ?? 'User '} !',
                      style: TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate()
                        .fadeIn(duration: 800.ms)
                        .slideX(begin: -0.3, duration: 800.ms),
                    SizedBox(height: 8),
                    Text(
                      'Let\'s check your plant\'s health',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ).animate()
                        .fadeIn(delay: 200.ms)
                        .slideX(begin: -0.3, duration: 800.ms),
                  ],
                ),
              ),
              if (!_isLoading) ...[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.all(16), // Adjusted padding
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (_imageData != null) _buildImagePreview(),
                      if (_imageData == null) ...[
                        Icon(
                          Icons.add_a_photo,
                          size: 48,
                          color: softGreen,
                        ).animate()
                            .fadeIn(duration: 800.ms)
                            .slideY(begin: 0.3, duration: 800.ms),
                        SizedBox(height: 16),
                        Text(
                          'Take or Upload a Photo',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ).animate()
                            .fadeIn(delay: 200.ms)
                            .slideY(begin: 0.3, duration: 800.ms),
                        SizedBox(height: 8),
                        Text(
                          'Get instant disease detection results',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600]),
                        ).animate()
                            .fadeIn(delay: 400.ms)
                            .slideY(begin: 0.3, duration: 800.ms),
                      ],
                      SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.photo_library,
                              label: 'Gallery',
                              onPressed: () => _pickImage(ImageSource.gallery),
                              color: softOrange,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildActionButton(
                              icon: Icons.camera_alt,
                              label: 'Camera',
                              onPressed: () => _pickImage(ImageSource.camera),
                              color: softBlue,
                            ),
                          ),
                        ],
                      ),
                      if (_imageData != null) ...[
                        SizedBox(height: 12),
                        _buildActionButton(
                          icon: Icons.search,
                          label: 'Analyze Plant',
                          onPressed: _analyzeImage,
                          color: softGreen,
                        ),
                      ],
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: 800.ms)
                    .slideY(begin: 0.3, duration: 800.ms),
                SizedBox(height: 24),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate()
                    .fadeIn(delay: 600.ms)
                    .slideX(begin: -0.3, duration: 800.ms),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      QuickActionCard(
                        title: 'Plant Care',
                        icon: Icons.eco,
                        color: softGreen,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PlantCarePage()),
                        ),
                      ).animate()
                          .fadeIn(delay: 800.ms)
                          .slideY(begin: 0.3, duration: 800.ms),
                      SizedBox(width: 16),
                      QuickActionCard(
                        title: 'Disease Library',
                        icon: Icons.medical_services,
                        color: softOrange,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DiseaseLibraryPage(),
                          ),
                        ),
                      ).animate()
                          .fadeIn(delay: 1000.ms)
                          .slideY(begin: 0.3, duration: 800.ms),
                      SizedBox(width: 16),
                      QuickActionCard(
                        title: 'History',
                        icon: Icons.history,
                        color: softBlue,
                        onTap: () {
                          // Add history functionality here
                        },
                      ).animate()
                          .fadeIn(delay: 1200.ms)
                          .slideY(begin: 0.3, duration: 800.ms),
                    ],
                  ),
                ),
              ],
              if (_isLoading)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(softGreen),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Analyzing your plant...',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ).animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}