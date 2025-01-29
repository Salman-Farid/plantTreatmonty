import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

Widget buildDrawerHeader(dynamic _fullName, dynamic _user) {
  return DrawerHeader(
    decoration: BoxDecoration(
      color: Colors.green[700],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: _user?.photoURL != null
              ? NetworkImage(_user!.photoURL!) // Use user's profile image
              : AssetImage('assets/profile.png') as ImageProvider, // Fallback to default asset
        ).animate().scale(begin: const Offset(0, 0)),
        SizedBox(height: 12),
        Text(
          _fullName ?? 'Guest',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(),
        Text(
          _user?.email ?? 'No Email',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ).animate().fadeIn(delay: 400.ms).slideX(),
      ],
    ),
  );
}