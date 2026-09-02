import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';

class AuthProvider extends ChangeNotifier {
  static const _usersKey = 'kb_users';
  static const _sessionKey = 'kb_session';

  final List<AppUser> _users = [];
  AppUser? _currentUser;
  bool _restoring = true;
  String? _lastError;

  AppUser? get user => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get restoring => _restoring;
  String? get lastError => _lastError;

  Future<void> restoreSession() async {
    _restoring = true;
    final prefs = await SharedPreferences.getInstance();

    final usersRaw = prefs.getString(_usersKey);
    if (usersRaw != null) {
      try {
        final list = jsonDecode(usersRaw) as List<dynamic>;
        _users
          ..clear()
          ..addAll(list
              .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
              .toList());
      } catch (_) {}
    }

    if (_users.isEmpty) {
      // Seed a demo account so the app can be shown immediately.
      _users.add(AppUser(
          name: 'Demo Farmer', email: 'demo@kisaan.in', password: 'demo123'));
      await _saveUsers();

      final email = prefs.getString(_sessionKey);
      if (email != null) {
        _currentUser = _users.where((u) => u.email == email).firstOrNull;
      }
    } else {
      final email = prefs.getString(_sessionKey);
      _currentUser = email == null ? null : _users.where((u) => u.email == email).firstOrNull;
    }

    _restoring = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _lastError = null;
    final user = _users.where((u) => u.email == email.trim().toLowerCase()).firstOrNull;
    if (user == null || user.password != password) {
      _lastError = 'Invalid email or password';
      notifyListeners();
      return false;
    }
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, user.email);
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    _lastError = null;
    final normEmail = email.trim().toLowerCase();
    if (_users.any((u) => u.email == normEmail)) {
      _lastError = 'An account with this email already exists';
      notifyListeners();
      return false;
    }
    final user = AppUser(name: name.trim(), email: normEmail, password: password);
    _users.add(user);
    await _saveUsers();
    _currentUser = user;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, user.email);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _currentUser = null;
    _lastError = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _usersKey, jsonEncode(_users.map((u) => u.toJson()).toList()));
  }
}