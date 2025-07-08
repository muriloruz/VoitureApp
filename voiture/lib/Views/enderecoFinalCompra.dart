import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Views/menuPrincipal.dart';

/* - Essa classe é chamada primeiro no cadastro do vendedor, depois no do usuário quando o mesmo for comprar a peça */
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Endereço',
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
      home: const EnderecoFinalCompra(),
    );
  }
}

class EnderecoFinalCompra extends StatefulWidget {
  const EnderecoFinalCompra({super.key});

  @override
  State<EnderecoFinalCompra> createState() => _EnderecoFinalCompraState();
}

class _EnderecoFinalCompraState extends State<EnderecoFinalCompra> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _unidadeController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _residenciaController = TextEditingController();

  

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _complementoController.dispose();
    _unidadeController.dispose();
    _ufController.dispose();
    _residenciaController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cadastro de Endereço'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MenuPrincipal()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: <Widget>[
              const Text('CEP'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: const InputDecoration(hintText: 'Digite o CEP'),
              ),
              const SizedBox(height: 16.0),
              const Text('Rua'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(hintText: 'Digite a rua'),
              ),
              const SizedBox(height: 16.0),
              const Text('Bairro'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(hintText: 'Digite o bairro'),
              ),
              const SizedBox(height: 16.0),
              const Text('Cidade'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(hintText: 'Digite a cidade'),
              ),
              const SizedBox(height: 16.0),
            
              const Text('Número da casa'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _residenciaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Digite o número'),
              ),
              const SizedBox(height: 16.0),
              const Text('UF'),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _ufController,
                maxLength: 2,
                decoration: const InputDecoration(hintText: 'Digite a UF'),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () async {
                  Usuario user = Usuario.instance;
                  ReqResp r = ReqResp(
                    "https://192.168.94.220:7101",
                    httpClient: createIgnoringCertificateClient(),
                  );
                  Map<String, dynamic> body = {
                    "uf": _ufController.text,
                    "CEP": _cepController.text,
                    "rua": _ruaController.text,
                    "Bairro": _bairroController.text,
                    "Cidade": _cidadeController.text,
                  };
                  http.Response resp = await r.post("Endereco", body);

                  if (resp.statusCode == 200) {
                    List<Map<String, dynamic>> bodyPatch = [
                      {
                        "op": "replace",
                        "path": "/EnderecoId",
                        "value": resp.body,
                      },
                      {
                        "op": "replace",
                        "path": "/numeroResid",
                        "value": _residenciaController.text, 
                      }
                    ];
                    http.Response response = await r.patch(
                      "usuario/${user.id}",
                      bodyPatch, 
                    );
                    if(response.statusCode == 204){
                      ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Endereço cadastrado com sucesso!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                      await Future.delayed(const Duration(seconds: 2));

                      Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));
                    }else{
                      print(response.statusCode);
                      print(response.body);
                    }
                  } else {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Erro de cadastro."),
                            content: Text("${resp.body},${resp.statusCode}"),
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
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
