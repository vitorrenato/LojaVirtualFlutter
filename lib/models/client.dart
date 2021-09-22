import 'package:flutter/material.dart';

class Client with ChangeNotifier {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl
  });
}