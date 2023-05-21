import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/screens/login_S.dart';
import 'package:supaverify/screens/navigate.dart';
import 'package:supaverify/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Supabase
  await Supabase.initialize(
      url: 'https://wbluqmcdevbqplwlbrop.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndibHVxbWNkZXZicXBsd2xicm9wIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQyNjE5MDcsImV4cCI6MTk5OTgzNzkwN30.EefiPxirGVClK5XXtl6rajGaRza8AKfyGY9smjYdP2E');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: secondary,
        fontFamily: 'Mark',
      ).copyWith(
        canvasColor: secondary,
        colorScheme: ThemeData().colorScheme.copyWith(
              primary: primary,
            ),
      ),
      home: AuthPage(),
    );
  }
}

// class for route management
class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    setState(() {
      _user = supabase.auth.currentUser;
    });
    supabase.auth.onAuthStateChange.listen((event) async {
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null)
      return loginS();
    else
      return NavigateS();
  }
}
