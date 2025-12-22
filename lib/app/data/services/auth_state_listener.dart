import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthStateListener extends StatefulWidget {
  final Widget Function(bool isAuthenticated) builder;

  const AuthStateListener({super.key, required this.builder});

  @override
  State<AuthStateListener> createState() => _AuthStateListenerState();
}

class _AuthStateListenerState extends State<AuthStateListener> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkInitialSession();
    _setupAuthListener();
  }

  void _checkInitialSession() {
    final session = Supabase.instance.client.auth.currentSession;
    setState(() {
      _isAuthenticated = session != null;
    });
  }

  void _setupAuthListener() {
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      setState(() {
        _isAuthenticated = session != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_isAuthenticated);
  }
}