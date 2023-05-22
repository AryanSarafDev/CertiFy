import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supaverify/screens/login_S.dart';
import 'package:supaverify/screens/navigate.dart';
import 'package:supaverify/utils/constants.dart';

Future main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  var url = dotenv.env['SUPABASE_URL'];
  var key = dotenv.env['SUPABASE_KEY'];
  //Initialize Supabase
  await Supabase.initialize(
      url: url!,
      anonKey:key!);
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
