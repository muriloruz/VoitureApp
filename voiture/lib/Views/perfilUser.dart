
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/alterarDados.dart';
import 'package:voiture/enderecoFinalCompra.dart';
import 'package:voiture/menuPrincipal.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;


/* -Classe StateFul (para entender mais, veja a classe "buscarUnicaPeca"), muda quando acionada para buscar os dados do usuario;
   -Classe destinada para o perfil do "cliente"(usuario com a role "usuario") 
*/

Future<String> fetchUsuario() async {
  final r = ReqResp(
    "https://192.168.18.61:7101",
    httpClient: createIgnoringCertificateClient(),
  );
  final dcPayload = r.decodeJwtToken(user.token);
  final id = dcPayload.toString().split(":")[1].split(",")[0].trim();
  final resp = await r.getByName("usuario/single/", id);
  return resp.body;
}

void main() => runApp(const PerfilUser());

class PerfilUser extends StatelessWidget {
  const PerfilUser({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF000000);
    const Color secondaryColor = Color(0xFF757575);
    const Color accentColor = Color(0xFF1E88E5);
    const Color backgroundColor = Color(0xFFF5F5F5);
    const Color inputFillColor = Color(0xFFE0E0E0);

    return MaterialApp(
      title: 'Perfil do Usuário',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          primary: primaryColor, primaryContainer: Color(0xFF424242),
          secondary: accentColor, secondaryContainer: Color(0xFF90CAF9), surface: Colors.white,
          error: Colors.red, onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: primaryColor, onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: backgroundColor,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
          bodyMedium: TextStyle(fontSize: 16, color: primaryColor),
          bodySmall: TextStyle(fontSize: 14, color: secondaryColor),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true, fillColor: inputFillColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: BorderSide.none),
          hintStyle: const TextStyle(color: secondaryColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: accentColor),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _usuarioFuture;

  @override
  void initState() {
    super.initState();
    _usuarioFuture = fetchUsuario().then((body) => jsonDecode(body));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "perfil"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _usuarioFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          final userJson = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField('Nome', userJson['nome']),
                const SizedBox(height: 12),
                _buildField('E‑mail', userJson['email']),
                const SizedBox(height: 12),
                _buildField('Celular', userJson['celular'] ?? '(não informado)'),
                const SizedBox(height: 12),
                _buildField('CPF', userJson['cpf']),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlterarDados()));
                    },
                    child: const Text('Alterar dados'),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EnderecoFinalCompra()));
                    },
                    child: const Text('Alterar Endereço'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar()
    );
  }

  Widget _buildField(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Theme.of(context).inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      );
}

