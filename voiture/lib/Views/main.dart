import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/Views/anunciarPecas.dart';
import 'package:voiture/Views/login.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Views/menuPrincipal.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  bool isLoggedIn = false;
  if (token == null) {
    isLoggedIn = false;
  } else {
    Usuario user = Usuario.instance;
    ReqResp r = new ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());

    Map<String, dynamic>? resp = r.decodeJwtToken(token);
    String? userId = resp?['id'];
    if (userId != null) {
      http.Response resId = await r.getByName("usuario/users/", userId);
      if(resId.statusCode == 200){
        final data = json.decode(resId.body);
        user.id = data['id'];
        user.token = token;
        isLoggedIn = true;
      }
    }
  }
  runApp(Main(isLoggedIn: isLoggedIn));
}

Future<bool> isTokenExpirado() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  if (token == null) return true;
  return false;
}

class Main extends StatelessWidget {
  final bool isLoggedIn;
  const Main({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Acesso',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        brightness: Brightness.dark,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade800,
          hintStyle: TextStyle(color: Colors.grey.shade400),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: isLoggedIn ? MenuPrincipal() : Login(),
    );
  }
}

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/voiturelogo.jpg',
              height: 150.0,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 48.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
