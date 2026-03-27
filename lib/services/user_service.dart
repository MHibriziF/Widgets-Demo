import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/user.dart';

class UserService {
  static Future<List<User>> loadUsers() async {
    final jsonString = await rootBundle.loadString('data.json');
    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
