import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Views/login.dart';

class AlterarSenha extends StatefulWidget {
  final String id;
  final String role;
  const AlterarSenha({Key? key, required this.id, required this.role})
    : super(key: key);

  @override
  State<AlterarSenha> createState() => _AlterarSenhaState();
}

class _AlterarSenhaState extends State<AlterarSenha> {
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _alterarSenha() async {
    if (_formKey.currentState!.validate()) {
      final String novaSenha = _senhaController.text;
      final String confirmarSenha = _confirmarSenhaController.text;

      print('ID Recebido: ${widget.id}');
      print('Nova Senha: $novaSenha');
      print('Confirmar Senha: $confirmarSenha');
      if (widget.role == 'USUARIO') {
        ReqResp r = new ReqResp(
          "https://192.168.18.61:7101",
          httpClient: createIgnoringCertificateClient(),
        );
        Map<String, dynamic> body = {
          "NewPassword": novaSenha,
          "ConfirmNewPassword": confirmarSenha,
        };
        http.Response resp = await r.post('usuario/password/${widget.id}', body);
        if (resp.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Senha Alterada!')));
          await Future.delayed(const Duration(seconds: 2));
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
        }else{
          print(resp.statusCode);
        }
      }else if(widget.role == 'VENDEDOR'){
        ReqResp r = new ReqResp(
          "https://192.168.18.61:7101",
          httpClient: createIgnoringCertificateClient(),
        );
        Map<String, dynamic> body = {
          "NewPassword": novaSenha,
          "ConfirmNewPassword": confirmarSenha,
        };
        http.Response resp = await r.post('Vendedor/password/${widget.id}', body);
        if (resp.statusCode == 200) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Senha Alterada!')));
          await Future.delayed(const Duration(seconds: 2));
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
        }else{
          print(resp.statusCode);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Alterar Senha'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Defina sua nova senha:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextFormField(
                controller: _senhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha',
                  hintText: 'Digite sua nova senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma senha.';
                  }
                  if (value.length < 6) {
                    return 'A senha deve ter pelo menos 6 caracteres.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                  hintText: 'Confirme sua nova senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_reset),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, confirme sua senha.';
                  }
                  if (value != _senhaController.text) {
                    return 'As senhas não coincidem.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _alterarSenha,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Alterar Senha',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
