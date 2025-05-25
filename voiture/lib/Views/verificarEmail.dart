import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Views/aletrarSenha.dart';

class VerificarEmail extends StatefulWidget {
  final String role;

  const VerificarEmail({Key? key, required this.role}) : super(key: key);

  @override
  State<VerificarEmail> createState() => _VerificarEmailState();
}

class _VerificarEmailState extends State<VerificarEmail> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late MaskTextInputFormatter _documentFormatter;
  String _documentLabel = '';
  String _documentHint = '';
  String _documentPattern = '';

  @override
  void initState() {
    super.initState();
    _initializeDocumentFormatter();
  }

  void _initializeDocumentFormatter() {
    if (widget.role == 'VENDEDOR') {
      _documentPattern = '##.###.###/####-##';
      _documentLabel = 'CNPJ';
      _documentHint = 'XX.XXX.XXX/XXXX-XX';
    } else if (widget.role == 'USUARIO') {
      _documentPattern = '###.###.###-##';
      _documentLabel = 'CPF';
      _documentHint = 'XXX.XXX.XXX-XX';
    } else {
      _documentPattern = '';
      _documentLabel = 'Documento';
      _documentHint = 'Insira seu documento';
    }

    _documentFormatter = MaskTextInputFormatter(
      mask: _documentPattern,
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _documentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificar Dados (${widget.role})'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'seu.email@example.com',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email.';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor, insira um email válido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _documentController,
                keyboardType: TextInputType.number,
                inputFormatters: [_documentFormatter],
                decoration: InputDecoration(
                  labelText: _documentLabel,
                  hintText: _documentHint,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      _documentFormatter.getUnmaskedText().isEmpty) {
                    return 'Por favor, insira o ${_documentLabel}.';
                  }
                  String unmasked = _documentFormatter.getUnmaskedText();
                  if (widget.role == 'VENDEDOR' && unmasked.length != 14) {
                    return 'CNPJ inválido (requer 14 dígitos).';
                  }
                  if (widget.role == 'USUARIO' && unmasked.length != 11) {
                    return 'CPF inválido (requer 11 dígitos).';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  String unmaskedDocument =
                      _documentFormatter.getUnmaskedText();
                  if (widget.role == "VENDEDOR") {
                    ReqResp r = new ReqResp(
                      "https://192.168.18.61:7101",
                      httpClient: createIgnoringCertificateClient(),
                    );
                    Map<String, dynamic> body = {
                      "Email": _emailController.text,
                      "CNPJ": unmaskedDocument,
                    };
                    http.Response resp = await r.post(
                      "Vendedor/verEmail",
                      body,
                    );
                    if (resp.statusCode == 200) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlterarSenha(id: resp.body, role: 'VENDEDOR')));
                    } else if (resp.statusCode == 404) {
                      String texto = resp.body;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Erro de verificação!',
                            ), 
                            content: Text(
                              texto
                            ), 
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); 
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  } else if (widget.role == "USUARIO") {
                    ReqResp r = new ReqResp(
                      "https://192.168.18.61:7101",
                      httpClient: createIgnoringCertificateClient(),
                    );
                    Map<String, dynamic> body = {
                      "Email": _emailController.text,
                      "CNPJ": unmaskedDocument,
                    };
                    http.Response resp = await r.post("usuario/verEmail", body); 
                    if (resp.statusCode == 200) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AlterarSenha(id: resp.body, role: 'USUARIO')));
                    } else if (resp.statusCode == 404) {
                      String texto = resp.body;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Erro de verificação!',
                            ), 
                            content: Text(
                              texto
                            ), 
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(
                                    context,
                                  ).pop(); 
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      print(resp.statusCode);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ir para mudar senha',
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
