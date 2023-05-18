import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/controllers/dropController.dart';
import 'package:supaverify/screens/login_S.dart';
import 'package:supaverify/screens/navigate.dart';
import 'package:supaverify/screens/org_S.dart';
import 'package:supaverify/screens/per_S.dart';
import 'package:supaverify/screens/register_S.dart';
import 'package:supaverify/utils/constants.dart';

String bools = "";

void main() async {
  final DropCont boolcont = Get.put(DropCont());
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  String supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  String supabaseKey = dotenv.env['SUPABASE_KEY'] ?? '';
  await Supabase.initialize(
      url: 'https://wbluqmcdevbqplwlbrop.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndibHVxbWNkZXZicXBsd2xicm9wIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODQyNjE5MDcsImV4cCI6MTk5OTgzNzkwN30.EefiPxirGVClK5XXtl6rajGaRza8AKfyGY9smjYdP2E');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final DropCont boolcont = Get.put(DropCont());
  final SupabaseClient supabase = Supabase.instance.client;
  User? _user;
  String? idd;
  var orga = false;
  var pers = false;
  var veri = false;
  void states() async {
    final idd = supabase.auth.currentUser!.email;
  }

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
    else return NavigateS();
  }
}
