import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/Views/menuPrincipal.dart';

class EnderecoAlterar extends StatelessWidget {
  const EnderecoAlterar({super.key});

  @override
  Widget build(BuildContext context) {
    return const CadastroEndVend();
  }
}

class CadastroEndVend extends StatefulWidget {
  const CadastroEndVend({super.key});

  @override
  State<CadastroEndVend> createState() => _CadastroEndVendState();
}

class _CadastroEndVendState extends State<CadastroEndVend> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _ufController = TextEditingController();
  final TextEditingController _residenciaController = TextEditingController();

  String _complementoOpcao = 'sem';

  @override
  void dispose() {
    _cepController.dispose();
    _ruaController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _complementoController.dispose();
    _ufController.dispose();
    _residenciaController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2),
      ),
    );
  }

  Widget _buildComplementoField() {
    if (_complementoOpcao == 'com') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Complemento', style: TextStyle(color: Colors.black)),
          const SizedBox(height: 8.0),
          TextFormField(
            controller: _complementoController,
            decoration: _inputDecoration('Digite o complemento'),
            style: const TextStyle(color: Colors.black),
          ),
          const SizedBox(height: 16.0),
        ],
      );
    } else {
      _complementoController.text = 'sem';
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: uS.UsedAppBar(nome: "Editar Perfil"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text('CEP', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                maxLength: 8,
                decoration: _inputDecoration('Digite o CEP'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),

              const Text('Rua', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _ruaController,
                decoration: _inputDecoration('Digite a rua'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),

              const Text('Bairro', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _bairroController,
                decoration: _inputDecoration('Digite o bairro'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),

              const Text('Cidade', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _cidadeController,
                decoration: _inputDecoration('Digite a cidade'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),

              const Text('Complemento', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              Row(
                children: <Widget>[
                  Radio<String>(
                    value: 'sem',
                    groupValue: _complementoOpcao,
                    onChanged: (String? value) {
                      setState(() {
                        _complementoOpcao = value!;
                      });
                    },
                  ),
                  const Text('Sem complemento', style: TextStyle(color: Colors.black)),
                  const SizedBox(width: 16.0),
                  Radio<String>(
                    value: 'com',
                    groupValue: _complementoOpcao,
                    onChanged: (String? value) {
                      setState(() {
                        _complementoOpcao = value!;
                      });
                    },
                  ),
                  const Text('Complemento', style: TextStyle(color: Colors.black)),
                ],
              ),
              _buildComplementoField(),

              const Text('Número da casa', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _residenciaController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration('Digite o número'),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16.0),

              const Text('UF', style: TextStyle(color: Colors.black)),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _ufController,
                maxLength: 2,
                decoration: _inputDecoration('Digite a UF'),
                style: const TextStyle(color: Colors.black),
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
                    int enderecoId = int.parse(resp.body);
                    List<Map<String, dynamic>> bodyVend = [{
                      "op": "replace",
                      "path": "/EnderecoId",
                      "value": enderecoId
                    }];
                    http.Response respFinal = await r.patch(
                      "Vendedor/${user.id}",
                      bodyVend,
                    );
                    if (respFinal.statusCode == 204 || respFinal.statusCode == 200) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPrincipal()),
                      );
                    } else {
                      _showAlert("Erro", "Falha ao atualizar vendedor.${respFinal.body}, ${respFinal.statusCode}");
                      print("${respFinal.body}, ${respFinal.statusCode}");
                    }
                  } else {
                    _showAlert("Erro de cadastro",
                        "Verifique os dados preenchidos. (${resp.statusCode})");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlert(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            child: const Text('Ok'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
