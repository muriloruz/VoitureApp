import 'dart:convert'; // Import for json.decode

import 'package:flutter/material.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/alterarEndereco.dart';
import 'package:voiture/cadastroEndVend.dart';
import 'package:voiture/login.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/perfilUser.dart';

void main() {
  runApp(const AlterarDados());
}

/*
  - Tela para edição de usuário;
  - Ela é do tipo "StateFul";
  - Ela também carrega os dados do usuário/vendedor na inicialização, permitindo edição dos mesmos.
*/
class AlterarDados extends StatelessWidget {
  const AlterarDados({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Cadastro/Edição',
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
  String _tipoUsuario = 'USUARIO';
  final TextEditingController _cpfCnpjController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _rPasswordController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  final Usuario _currentUser = Usuario.instance;

  @override
  void initState() {
    super.initState();
    _tipoUsuario = _currentUser.role ?? 'USUARIO';
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final String? userId = _currentUser.id;
    if (userId == null) {
      print('User ID is null. Cannot fetch user data.');
      return;
    }

    ReqResp r = ReqResp(
      "https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient(),
    );

    String url;
    if (_tipoUsuario == 'USUARIO') {
      url = "usuario/single/$userId";
    } else if (_tipoUsuario == 'VENDEDOR') {
      url = "Vendedor/$userId";
    } else {
      print('Unknown user role: $_tipoUsuario');
      return;
    }

    try {
      final http.Response response = await r.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(response.body);
        setState(() {
          _nomeController.text = data['nome'] ?? '';
          _emailController.text = data['userName'] ?? '';
          if (_tipoUsuario == 'USUARIO')
            _telefoneController.text = data['phoneNumber'] ?? '';
          else if (_tipoUsuario == 'VENDEDOR')
            _telefoneController.text = data['telefoneVend'] ?? '';
          if (_tipoUsuario == 'USUARIO') {
            _cpfCnpjController.text = data['cpf'] ?? '';
          } else if (_tipoUsuario == 'VENDEDOR') {
            _cpfCnpjController.text = data['cnpj'] ?? '';
          }
        });
      } else {
        print(
          'Failed to fetch user data: ${response.statusCode} - ${response.body}',
        );
        _showErrorDialog(
          'Erro ao carregar dados',
          'Não foi possível carregar os dados do usuário. Por favor, tente novamente.',
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      _showErrorDialog(
        'Erro de conexão',
        'Não foi possível conectar ao servidor. Verifique sua conexão ou tente novamente mais tarde.',
      );
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text('Ok'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _rPasswordController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  Widget _buildCpfCnpjField() {
    if (_tipoUsuario == 'USUARIO') {
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
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 24.0),
              const Text('Nome completo'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(hintText: 'Seu Nome'),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('E-mail'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'seu@email.aqui'),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu e-mail.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um e-mail válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              const Text('Telefone'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _telefoneController,
                decoration: const InputDecoration(hintText: 'Seu Telefone'),
                style: const TextStyle(color: Colors.black),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu número de telefone.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              _buildCpfCnpjField(),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String endpoint = '';
                    if (_tipoUsuario == "USUARIO") {
                      endpoint = "usuario/";
                    } else if (_tipoUsuario == "VENDEDOR") {
                      endpoint = "Vendedor/";
                    } else {
                      _showErrorDialog('Erro', 'Tipo de usuário desconhecido.');
                      return;
                    }
                    Map<String, dynamic> body = {
                      'UserName': _emailController.text,
                      'Nome': _nomeController.text,
                      'email': _emailController.text,
                      'Password': _passwordController.text,
                      'ConfSenha': _rPasswordController.text,
                    };

                    if (_tipoUsuario == "USUARIO") {
                      body['cpf'] = _cpfCnpjController.text;
                    } else if (_tipoUsuario == "VENDEDOR") {
                      body['cnpj'] = _cpfCnpjController.text;
                    }

                    ReqResp r = ReqResp(
                      "https://192.168.18.61:7101",
                      httpClient: createIgnoringCertificateClient(),
                    );

                    http.Response resposta;

                    if (_currentUser.id!.isNotEmpty) {
                      print("Updating user data...");

                      List<Map<String, dynamic>> patchOperations = [
                        if (_tipoUsuario == "USUARIO")
                          {
                            "op": "replace",
                            "path": "/nome",
                            "value": _nomeController.text,
                          }
                        else if (_tipoUsuario == "VENDEDOR")
                          {
                            "op": "replace",
                            "path": "/nome",
                            "value": _nomeController.text,
                          },
                        {
                          "op": "replace",
                          "path": "/userName",
                          "value": _emailController.text,
                        },
                        if (_tipoUsuario == "USUARIO")
                          {
                            "op": "replace",
                            "path": "/phoneNumber",
                            "value": _telefoneController.text,
                          }
                        else if (_tipoUsuario == "VENDEDOR")
                          {
                            "op": "replace",
                            "path": "/telefoneVend",
                            "value": _telefoneController.text,
                          },
                        if (_tipoUsuario == "USUARIO")
                          {
                            "op": "replace",
                            "path": "/cpf",
                            "value": _cpfCnpjController.text,
                          }
                        else if (_tipoUsuario == "VENDEDOR")
                          {
                            "op": "replace",
                            "path": "/cnpj",
                            "value": _cpfCnpjController.text,
                          },
                        {
                          "op": "replace",
                          "path": "/userName",
                          "value": _emailController.text,
                        },
                      ];

                      resposta = await r.patch(
                        '$endpoint${_currentUser.id}',
                        patchOperations,
                      );
                    } else {
                      print("Registering new user...");
                      resposta = await r.post(endpoint, body);
                    }

                    if (resposta.statusCode == 200 ||
                        resposta.statusCode == 204) {
                      print('Request successful: ${resposta.body}');
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text("Sucesso!"),
                              content: const Text("Dados salvos com sucesso!"),
                              actions: [
                                TextButton(
                                  child: const Text('Ok'),
                                  onPressed: () {
                                    if (_tipoUsuario == "VENDEDOR") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  const EnderecoAlterar(),
                                        ),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => const PerfilUser(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                      );
                    } else if (resposta.statusCode == 400) {
                      _showErrorDialog(
                        "Erro de validação",
                        "Verifique os dados inseridos: ${resposta.body}",
                      );
                    } else if (resposta.statusCode == 409) {
                      _showErrorDialog(
                        "Erro de cadastro",
                        "Email ou CPF/CNPJ já cadastrado.",
                      );
                    } else {
                      _showErrorDialog(
                        "Erro na requisição",
                        "Código: ${resposta.statusCode}, Mensagem: ${resposta.body}",
                      );
                    }
                  } else {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    _showErrorDialog(
                      "Campos Inválidos",
                      "Por favor, preencha todos os campos corretamente.",
                    );
                  }
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
