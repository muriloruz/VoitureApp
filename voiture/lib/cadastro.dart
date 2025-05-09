import 'package:flutter/material.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/cadastroEndVend.dart';
import 'package:voiture/login.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
void main() {
  runApp(const Cadastro());
}
/*
  - Tela para cadastro de usuário;
  - Ela é do tipo "StateFul" (Para saber mais veja a classe "BuscarUnicaPeca");
  - Ela pode mudar o estado para receber ou o cpf ou cnpj do usuario (CPF = Cliente, CNPJ = Vendedor);
  - Vale destacar que esse modelo que esta sendo usado para fazer a requisição, é diferente do cadastro de peça.
 */
class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Cadastro',
      theme: ThemeData(
        brightness: Brightness.light, 
        primarySwatch: Colors.grey,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), 
          labelMedium: TextStyle(color: Colors.black),
          titleMedium: TextStyle(color: Colors.black),
          bodySmall: TextStyle(color: Colors.black),
          labelSmall: TextStyle(color: Colors.black),
          titleSmall: TextStyle(color: Colors.black),
          displaySmall: TextStyle(color: Colors.black),
          headlineSmall: TextStyle(color: Colors.black),
          displayMedium: TextStyle(color: Colors.black),
          headlineMedium: TextStyle(color: Colors.black),
          displayLarge: TextStyle(color: Colors.black),
          headlineLarge: TextStyle(color: Colors.black),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black), 
          ),
          filled: true,
          fillColor: Colors.white, 
          hintStyle: TextStyle(color: Colors.grey.shade600),
          labelStyle: const TextStyle(color: Colors.black),
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
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const CadastroScreen(),
    );
  }
}

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
  String _tipoUsuario = 'cliente'; // Valor inicial
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(); 
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rPasswordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();


  @override
  void dispose() {
    _scrollController.dispose();
    _cpfCnpjController.dispose();
    super.dispose();
  }

  Widget _buildCpfCnpjField() {
    if (_tipoUsuario == 'cliente') {
      return TextFormField(
        controller: _cpfCnpjController,
        keyboardType: TextInputType.number,
        maxLength: 11,
        decoration: const InputDecoration(
          labelText: 'CPF',
          hintText: 'Digite seu CPF',
          
        ),
        style: const TextStyle(color: Colors.black), 
      );
    } else {
      return TextFormField(
        controller: _cpfCnpjController,
        keyboardType: TextInputType.number,
        maxLength: 14,
        decoration: const InputDecoration(
          labelText: 'CNPJ',
          hintText: 'Digite seu CNPJ',
        ),
        style: const TextStyle(color: Colors.black), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      appBar: AppBar(
        title: const Text('Cadastre-se'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
        ),
      ),
      body: SingleChildScrollView( // ScrollView Serve para adicionar o efeito de rolagem na tela do celular
        child: Column( 
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Container(
                        color: Colors.black,
                        child: Padding(
                          padding: EdgeInsets.zero,
                          
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    const Text(
                      'Nome completo',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        hintText: 'Seu Nome',
                      ),
                      style: const TextStyle(color: Colors.black), 
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'E-mail',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'seu@email.aqui',
                      ),
                      style: const TextStyle(color: Colors.black), 
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Senha',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscureSenha,
                      decoration: InputDecoration(
                        hintText: '*******',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureSenha ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureSenha = !_obscureSenha;
                            });
                          },
                        ),
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black), 
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Confirme sua senha',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      controller: _rPasswordController,
                      obscureText: _obscureConfirmarSenha,
                      decoration: InputDecoration(
                        hintText: '*******',
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmarSenha ? Icons.visibility : Icons.visibility_off,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmarSenha = !_obscureConfirmarSenha;
                            });
                          },
                        ),
                        labelStyle: const TextStyle(color: Colors.black),
                      ),
                      style: const TextStyle(color: Colors.black), 
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'CPF', // Campo inicial
                    ),
                    const SizedBox(height: 8.0),
                    _buildCpfCnpjField(),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Tipo de usuário',
                    ),
                    Row(
                      children: <Widget>[
                        Radio<String>(
                          value: 'cliente',
                          groupValue: _tipoUsuario,
                          onChanged: (String? value) {
                            setState(() {
                              _tipoUsuario = value!;
                            });
                          },
                        ),
                        const Text('Cliente'),
                        const SizedBox(width: 16.0),
                        Radio<String>(
                          value: 'vendedor',
                          groupValue: _tipoUsuario,
                          onChanged: (String? value) {
                            setState(() {
                              _tipoUsuario = value!;
                            });
                          },
                        ),
                        const Text('Vendedor'),
                      ],
                    ),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () async{
                        if (_formKey.currentState!.validate()) {
                          
                          if(_tipoUsuario == "cliente"){
                            Usuario user = Usuario.instance;
                            user.nome = _nomeController.text;
                            user.email = _emailController.text;
                            user.cpf = _cpfCnpjController.text;
                            user.password = _passwordController.text;
                            if(_passwordController.text == _rPasswordController.text){
                              if(user.nome == "" || user.cpf == "" || user.email == "" || user.password == ""){
                                showDialog(
                                context: context,
                                builder:  (context) => AlertDialog(
                                  title: Text("Erro de cadastro."),
                                  content: Text("Verifique se todos os campos foram preenchidos."),
                                  actions: [
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                              }else{
                                
                                void cad() async{
                                  ReqResp r = ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());
                                  Map<String,dynamic> body = {
                                    'UserName': _emailController.text,
                                    'Nome': _nomeController.text,
                                    'cpf': _cpfCnpjController.text,
                                    'Password': _passwordController.text,
                                    'ConfSenha': _rPasswordController.text,
                                    'email': _emailController.text
                                  };
                                  http.Response resposta = await r.post("usuario/",body);
                                  if(resposta.statusCode == 200){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const Login())
                                    );
                                  }if(resposta.statusCode == 400){
                                    showDialog(
                                      context: context,
                                      builder:  (context) => AlertDialog(
                                      title: Text("Erro de cadastro."),
                                      content: Text("Verifique se todos os campos foram preenchidos."),
                                      actions: [
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                  }else if(resposta.statusCode == 500){
                                    showDialog(
                                      context: context,
                                      builder:  (context) => AlertDialog(
                                      title: Text("Erro de cadastro."),
                                      content: Text("Email já cadastrado."),
                                      actions: [
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                  }
                                }
                                cad();
                              }
                              
                            }else{
                              showDialog(
                                context: context,
                                builder:  (context) => AlertDialog(
                                  title: Text("Erro de cadastro."),
                                  content: Text("Os campos referentes as senhas não são iguais."),
                                  actions: [
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }else{
                            Usuario user = Usuario.instance;
                            user.nome = _nomeController.text;
                            user.email = _emailController.text;
                            user.cpf = _cpfCnpjController.text;
                            user.password = _passwordController.text;
                            if(_passwordController.text == _rPasswordController.text){
                              if(user.nome.trim().isEmpty || user.cpf.trim().isEmpty || user.email.trim().isEmpty || user.password.trim().isEmpty){
                                showDialog(
                                context: context,
                                builder:  (context) => AlertDialog(
                                  title: Text("Erro de cadastro."),
                                  content: Text("Verifique se todos os campos foram preenchidos."),
                                  actions: [
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                              }else{
                                ReqResp r = ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());
                                http.Response resp = await r.getByName("vendedor/verEmail/",user.email);
                                if(resp.statusCode == 200){
                                  showDialog(
                                      context: context,
                                      builder:  (context) => AlertDialog(
                                      title: Text("Erro de cadastro."),
                                      content: Text("Email já cadastrado."),
                                      actions: [
                                        TextButton(
                                          child: Text('Ok'),
                                          onPressed: () => Navigator.pop(context),
                                        ),
                                      ],
                                    ),
                                  );
                                }else{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const CadastroEndVend())
                                    );
                                }
                              }
                              
                            }else{
                              showDialog(
                                context: context,
                                builder:  (context) => AlertDialog(
                                  title: Text("Erro de cadastro."),
                                  content: Text("Os campos referentes as senhas não são iguais."),
                                  actions: [
                                    TextButton(
                                      child: Text('Ok'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                ),
                              );
                            }
                              
                          }
                          print('Cadastrar!');
                        } else {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: const Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}