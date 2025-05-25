import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/Views/menuPrincipal.dart';
import 'package:path/path.dart' as p;

Usuario user = Usuario.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AtualizarPeca extends StatefulWidget {
  final int idPeca;

  const AtualizarPeca({super.key, required this.idPeca});

  @override
  State<AtualizarPeca> createState() => _AtualizarPecaScreenState();
}

class _AtualizarPecaScreenState extends State<AtualizarPeca> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomePecaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _garantiaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  File? _imagemSelecionada;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = true;
  String? _currentImageFilename;

  static const String _imageBaseUrl = "https://192.168.18.61:7101/imagens/";
  static const String _apiBaseUrl = "https://192.168.18.61:7101";


  @override
  void initState() {
    super.initState();
    _fetchPecaData();
  }

  Future<void> _fetchPecaData() async {
    setState(() {
      _isLoading = true;
    });

    ReqResp r = ReqResp(
      _apiBaseUrl,
      httpClient: createIgnoringCertificateClient(),
    );

    try {
      final http.Response response = await r.get("peca/${widget.idPeca}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          _nomePecaController.text = data['nomePeca'] ?? '';
          _modeloController.text = data['fabricante'] ?? '';
          _quantidadeController.text = data['qntd']?.toString() ?? '';
          _valorController.text = data['preco']?.toString() ?? '';
          _garantiaController.text = data['garantia'] ?? '';
          _descricaoController.text = data['descricao'] ?? '';
          _currentImageFilename = data['imagem'];
        });
      } else {
        print('Erro ao carregar dados da peça. Código: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        _showErrorDialog('Erro ao carregar peça', 'Não foi possível carregar os dados da peça. Por favor, tente novamente.');
      }
    } catch (e) {
      print('Erro na requisição GET: $e');
      _showErrorDialog('Erro de conexão', 'Não foi possível conectar ao servidor para carregar a peça.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updatePecaComImagem({
    required BuildContext context,
    required String nome,
    required String descricao,
    required String modelo,
    required String qntd,
    required String valor,
    required String garantia,
    File? imagemFile,
    required String vendId,
    required int idPeca,
  }) async {
    final uri = Uri.parse("$_apiBaseUrl/peca/$idPeca");

    final request = http.MultipartRequest('PATCH', uri);

    request.fields['nomePeca'] = nome;
    request.fields['descricao'] = descricao;
    request.fields['garantia'] = garantia;
    request.fields['fabricante'] = modelo;
    request.fields['qntd'] = qntd;
    final valor1 = valor.replaceAll(".", "").replaceAll(",", ".");
    request.fields['preco'] = valor1;
    request.fields['VendedorId'] = vendId;

    if (imagemFile != null) {
      final imagemStream = http.ByteStream(imagemFile.openRead());
      final imagemLength = await imagemFile.length();

      final multipartFile = http.MultipartFile(
        'imagem',
        imagemStream,
        imagemLength,
        filename: p.basename(imagemFile.path),
      );
      request.files.add(multipartFile);
    }

    final client = createIgnoringCertificateClient();

    try {
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Peça alterada com sucesso!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 2));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MenuPrincipal(),
          ),
        );
      } else if (response.statusCode == 400) {
        print('Erro de validação ao alterar peça. Código: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        _showErrorDialog('Erro de validação', 'Verifique os dados: ${response.body}');
      } else {
        print('Erro ao alterar peça. Código: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        _showErrorDialog('Erro ao alterar peça', 'Ocorreu um erro inesperado. Código: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição PATCH: $e');
      _showErrorDialog('Erro de conexão', 'Não foi possível conectar ao servidor para alterar a peça.');
    } finally {
      client.close();
    }
  }

  Future<void> _escolherImagemGaleria() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
        _currentImageFilename = null;
      });
      print('Imagem selecionada da galeria: ${_imagemSelecionada?.path}');
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  Future<void> _tirarFotoCamera() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
        _currentImageFilename = null;
      });
      print('Foto tirada da câmera: ${_imagemSelecionada?.path}');
    } else {
      print('Nenhuma foto tirada.');
    }
  }

  void _mostrarEscolhaImagem() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecionar Imagem'),
        content: const Text('Escolha de onde deseja pegar a imagem.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _escolherImagemGaleria();
            },
            child: const Text('Galeria'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tirarFotoCamera();
            },
            child: const Text('Câmera'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
    _nomePecaController.dispose();
    _modeloController.dispose();
    _quantidadeController.dispose();
    _valorController.dispose();
    _garantiaController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 160.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
          child: Image.asset(
            'assets/voiturelogo.jpg',
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        actions: const [SizedBox(width: 48)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Alterar Peça',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(_nomePecaController, 'Nome da peça',
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O nome da peça é obrigatório';
                              }
                              return null;
                            }),
                            const SizedBox(height: 14.0),
                            _buildTextField(_modeloController, 'Modelo',
                                validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'O modelo é obrigatório';
                              }
                              return null;
                            }),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              _quantidadeController,
                              'Quantidade a ser anunciada',
                              maxLength: 9,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'A quantidade é obrigatória';
                                }
                                if (int.tryParse(value) == null || int.parse(value) <= 0) {
                                  return 'Insira uma quantidade válida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              _valorController,
                              'Valor da peça (R\$)',
                              keyboardType: const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'O valor é obrigatório';
                                }
                                if (double.tryParse(value.replaceAll(",", ".")) == null || double.parse(value.replaceAll(",", ".")) <= 0) {
                                  return 'Insira um valor válido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            _buildTextField(_garantiaController, 'Garantia (opcional)'),
                            const SizedBox(height: 16.0),
                            _buildTextField(
                              _descricaoController,
                              'Descrição (opcional)',
                              maxLines: 3,
                            ),
                            if (_imagemSelecionada != null) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.file(
                                    _imagemSelecionada!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ] else if (_currentImageFilename != null && _currentImageFilename!.isNotEmpty) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: Image.network(
                                    '$_imageBaseUrl${_currentImageFilename!}',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(child: Text('Não foi possível carregar a imagem.')),
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 24.0),
                            _buildOutlinedButton('Alterar Imagem', () {
                              _mostrarEscolhaImagem();
                            }),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (_imagemSelecionada == null && (_currentImageFilename == null || _currentImageFilename!.isEmpty)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Por favor, selecione uma imagem.'),
                                        ),
                                      );
                                      return;
                                    }

                                    await _updatePecaComImagem(
                                      context: context,
                                      nome: _nomePecaController.text,
                                      descricao: _descricaoController.text,
                                      imagemFile: _imagemSelecionada,
                                      garantia: _garantiaController.text,
                                      qntd: _quantidadeController.text,
                                      modelo: _modeloController.text,
                                      valor: _valorController.text,
                                      vendId: user.id,
                                      idPeca: widget.idPeca,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Por favor, preencha todos os campos obrigatórios corretamente.'),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text(
                                  'Alterar',
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Widget _buildOutlinedButton(String text, VoidCallback onTap) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.grey[300],
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Center(
            child: Text(text, style: const TextStyle(color: Colors.black)),
          ),
        ),
      ),
    );
  }
}