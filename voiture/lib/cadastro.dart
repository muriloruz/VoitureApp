import 'package:flutter/material.dart';
import 'package:voiture/login.dart';

void main() {
  runApp(const Cadastro());
}

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tela de Cadastro',
      theme: ThemeData(
        brightness: Brightness.light, // Fundo branco
        primarySwatch: Colors.grey,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Cor padrão do texto
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
            borderSide: const BorderSide(color: Colors.black), // Borda preta
          ),
          filled: true,
          fillColor: Colors.white, // Fundo branco dos inputs
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
  TextEditingController _cpfCnpjController = TextEditingController();

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
        decoration: const InputDecoration(
          labelText: 'CPF',
          hintText: 'Digite seu CPF',
        ),
        style: const TextStyle(color: Colors.black), // Cor do texto digitado
      );
    } else {
      return TextFormField(
        controller: _cpfCnpjController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'CNPJ',
          hintText: 'Digite seu CNPJ',
        ),
        style: const TextStyle(color: Colors.black), // Cor do texto digitado
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fundo branco da tela
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
      body: SingleChildScrollView( // Envolve tudo para permitir a rolagem
        child: Column( // Coluna principal com a imagem e o formulário
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
                        color: Colors.transparent,
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
                      decoration: const InputDecoration(
                        hintText: 'Jorge de Souza',
                      ),
                      style: const TextStyle(color: Colors.black), // Cor do texto digitado
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'E-mail',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'jorge@gmail.com',
                      ),
                      style: const TextStyle(color: Colors.black), // Cor do texto digitado
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Senha',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
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
                      style: const TextStyle(color: Colors.black), // Cor do texto digitado
                    ),
                    const SizedBox(height: 16.0),
                    const Text(
                      'Confirme sua senha',
                    ),
                    const SizedBox(height: 8.0),
                    TextFormField(
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
                      style: const TextStyle(color: Colors.black), // Cor do texto digitado
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Lógica de cadastro aqui
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