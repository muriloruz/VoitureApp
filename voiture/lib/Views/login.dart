import 'dart:convert';


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voiture/cadastro.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/menuPrincipal.dart';
void main() {
  runApp(const Login());
}
/* Primeira tela complexa que aparece quando o usuario, ela usa a classe ReqResp para requisição na API */


void getToken() async{
  ReqResp r = ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());
  final dcPaylod = r.decodeJwtToken(user.token);
  String resp = dcPaylod.toString();
  var priQuebra = resp.split(":");
  var segQuebra = priQuebra[1].split(",");
  try{
    final http.Response resposta = await r.getByName("usuario/single/",segQuebra[0].trim());
    Map<String, dynamic> jsonData = jsonDecode(resposta.body);
    String id = jsonData['id'];
    user.id = id;
    
  }catch(err){
    final http.Response resposta = await r.getByName("Vendedor/",segQuebra[0].trim());
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
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Com o e-mail e senha',
                  style: TextStyle(color: Colors.black),
                ),
                const SizedBox(height: 24.0),
                const Text('Digite seu e-mail', style: TextStyle(color: Colors.black)),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'E-mail',
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text('Digite sua senha', style: TextStyle(color: Colors.black)),
                const SizedBox(height: 8.0),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
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
                          value: false,
                          onChanged: (bool? value) {},
                        ),
                        const Text('Lembrar senha', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Esqueci minha senha', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                const SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () async{    
                 try{
                    ReqResp r = ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());
                    final String email = _emailController.text;
                    final String password = _passwordController.text;
                    final Map<String, dynamic> loginData = {
                     'email': email,
                     'password': password,
                    };
                    final http.Response response = await r.post('usuario/login',loginData);
                    if(response.statusCode == 200){
                        Usuario user = Usuario.instance;
                        user.token=response.body;
                        getToken();
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                      );
                        await Future.delayed(Duration(seconds: 2));
                    }else if(response.statusCode == 400){
                           
                        showDialog(
                          context: context,
                          builder:  (context) => AlertDialog(
                            title: Text("Erro de login"),
                            content: Text("Verifique se digitou todos os campos"),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2));
                    }else if(response.statusCode == 404){
                        if(response.body == "Email não encontrado"){
                          showDialog(
                          context: context,
                          builder:  (context) => AlertDialog(
                            title: Text("Erro de login"),
                            content: Text("Verifique o campo de Email"),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2));
                        }else{
                          showDialog(
                          context: context,
                          builder:  (context) => AlertDialog(
                            title: Text("Erro de login"),
                            content: Text("Verifique o campo de Senha"),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2));
                        }
                    }
                  }catch(err){
                     if(err is TypeError){
                      showDialog(
                          context: context,
                          builder:  (context) => AlertDialog(
                            title: Text("Erro de login"),
                            content: Text("Verifique se digitou todos os campos"),
                            actions: [
                              TextButton(
                                child: Text('Ok'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                        await Future.delayed(Duration(seconds: 2));
                    }
                  }  
                  },
                  child: const Text('Acessar'),
                ),
                const SizedBox(height: 16.0),
                OutlinedButton(
                  onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Cadastro()),
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