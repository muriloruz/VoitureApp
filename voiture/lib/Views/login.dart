import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart' as shp;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voiture/Views/cadastro.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Views/menuPrincipal.dart';
import 'package:voiture/Views/tipoUser.dart' as t;

void main() {
  runApp(const Login());
}
/* Primeira tela complexa que aparece quando o usuario, ela usa a classe ReqResp para requisição na API */
Future<http.Response?> _tryLogin(
  ReqResp r, 
  String endpoint, 
  Map<String, dynamic> data
) async {
  try {
    final response = await r.post(endpoint, data);
    if (response.statusCode == 200) return response;
    return null;
  } catch (e) {
    return null;
  }
}
void getToken() async {
  ReqResp r = ReqResp(
    "https://192.168.94.220:7101",
    httpClient: createIgnoringCertificateClient(),
  );
  final dcPaylod = r.decodeJwtToken(user.token);
  String resp = dcPaylod.toString();
  var priQuebra = resp.split(":");
  var segQuebra = priQuebra[1].split(",");
  try {
    final http.Response resposta = await r.getByName(
      "usuario/single/",
      segQuebra[0].trim(),
    );
    Map<String, dynamic> jsonData = jsonDecode(resposta.body);
    String id = jsonData['id'];
    user.id = id;
  } catch (err) {
    final http.Response resposta = await r.getByName(
      "Vendedor/",
      segQuebra[0].trim(),
    );
    Map<String, dynamic> jsonData = jsonDecode(resposta.body);
    String id = jsonData['id'];
    user.id = id;
  }
}

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Acesso',
      theme: ThemeData(
        brightness: Brightness.light,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.black),
          ),
          filled: true,
          fillColor: Colors.white,
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
            foregroundColor: Colors.black,
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dio = Dio();
  bool valor = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              'assets/voiturelogo.jpg',
              height: 160.0,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 32.0),
                  const Text(
                    'Acessar',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Com o e-mail e senha',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Digite seu e-mail',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(hintText: 'E-mail'),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Digite sua senha',
                    style: TextStyle(color: Colors.black),
                  ),
                  const SizedBox(height: 8.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: valor,
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (states) {
                                if (states.contains(MaterialState.selected)) {
                                  return Colors.blue;
                                }
                                return Colors.white;
                              },
                            ),
                            checkColor: Colors.white,
                            onChanged: (bool? novoValor) {
                              setState(() {
                                valor = novoValor ?? false;
                              });
                            },
                          ),
                          const Text(
                            'Lembrar senha',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => t.TipoUser(),
                            ),
                          );
                        },
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text;
                      final password = _passwordController.text;
                      final r = ReqResp(
                        "https://192.168.94.220:7101",
                        httpClient: createIgnoringCertificateClient(),
                      );
                      var response = await _tryLogin(r, 'usuario/login', {
                        'email': email,
                        'password': password,
                      });
                      if (response == null) {
                        response = await _tryLogin(r, 'Vendedor/login', {
                          'UserName': email,
                          'Password': password,
                        });
                        print(response);
                      }
                      if (response != null && response.statusCode == 200) {
                        Usuario user = Usuario.instance;
                        user.token = response.body;
                        getToken(); 

                        final prefs = await shp.SharedPreferences.getInstance();
                        if (valor) {
                          await prefs.setString('token', user.token);
                        } else {
                          await prefs.remove('token');
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MenuPrincipal(),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("Erro de login"),
                                content: const Text("Credenciais inválidas"),
                                actions: [
                                  TextButton(
                                    child: const Text('Ok'),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                        );
                      }
                    },
                    child: const Text('Acessar'),
                  ),
                  const SizedBox(height: 16.0),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Cadastro(),
                        ),
                      );
                    },
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
