
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/PerfilVend.dart';
import 'package:voiture/menuPrincipal.dart';
import 'package:http/io_client.dart' as io;
import 'package:voiture/perfilUser.dart';

/// Executa a requisição e retorna o JSON do usuário
Future<String> fetchUsuario() async {
  final r = ReqResp(
    "https://192.168.18.61:7101",
    httpClient: createIgnoringCertificateClient(),
  );
  //final payload = r.decodeJwtToken('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjBhMDkxYmI4LTAzMmQtNGM3ZC1iYjhjLWU2OTJlMDk1MDUyZiIsInVzZXJuYW1lIjoic3NhQGdtYWlsLmNvbSIsIm5vbWUiOiJqb2FvIiwiZXhwIjoxNzQ2NzIwMDE4fQ.d_yrFWahmkF7czMaLMr8BIHhYlYo5afGnoUL036rzs4');
  final dcPayload = r.decodeJwtToken(user.token);
  final id = dcPayload.toString().split(":")[1].split(",")[0].trim();
  final resp = await r.getByName("Vendedor/", id);
  return resp.body;
}

void main() => runApp(const PerfilVend());

class PerfilVend extends StatelessWidget {
  const PerfilVend ({super.key});

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
          secondary: accentColor, secondaryContainer: Color(0xFF90CAF9),
          background: backgroundColor, surface: Colors.white,
          error: Colors.red, onPrimary: Colors.white,
          onSecondary: Colors.white, onBackground: primaryColor,
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
      appBar: AppBar(
        title: const Text('Perfil do Usuário'),
        centerTitle: true,
      ),
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
                _buildField('E‑mail', userJson['userName']),
                const SizedBox(height: 12),
                _buildField('Celular', userJson['telefoneVend'] ?? '(não informado)'),
                const SizedBox(height: 12),
                _buildField('CNPJ', userJson['cnpj']),
                const Spacer(),
                Row(
        children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação ao salvar
                    },
                    child: const Text('Salvar'),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Ação para forma de pagamento
                    },
                    
                    child: const Text('Forma de pagamento',style: TextStyle(fontSize: 12.0)),
                    
                    
                  ),
                ),
              ],
      		),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: Colors.black,
       
        padding: const EdgeInsets.symmetric(vertical: 8),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_outlined, 'Menu', () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuPrincipal()));
            }),
            _navItem(Icons.list_alt_outlined, 'Pedidos', () {}),
            _navItem(Icons.shopping_cart_outlined, 'Carrinho', () {}),
            _navItem(Icons.person, 'Perfil', () {
              if (Usuario.instance.role == 'USUARIO') {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilUser()));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilVend()));
              }
            }),
          ],
        ),
      ),
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

  Widget _navItem(IconData icon, String label, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      );
}

