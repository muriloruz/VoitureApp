import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/menuPrincipal.dart';
import 'package:path/path.dart' as p;
/*
  - Tela para criar anuncio de peça;
  - Essa classe usa outro tipod e logica para fazer as requisições;
  - Ela precisa ser diferente pois ela manda uma imagem, que é a imagem da peça.
 */
Usuario user = Usuario.instance;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class AnunciarPeca extends StatefulWidget {
  const AnunciarPeca({super.key});

  @override
  State<AnunciarPeca> createState() => _AnunciarPecaScreenState();
}

class _AnunciarPecaScreenState extends State<AnunciarPeca> {
  final TextEditingController _nomePecaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _garantiaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  File? _imagemSelecionada; 
  final ImagePicker _picker = ImagePicker();

  bool pecaCriada = false;


  Future<void> enviarPecaComImagem({
    required BuildContext context,
    required String nome,
    required String descricao,
    required String modelo,
    required String qntd,
    required String valor,
    required String garantia,
    required File imagemFile,
    required String vendId,
  }) async {
    final uri = Uri.parse("https://192.168.18.61:7101/peca");

    final request = http.MultipartRequest('POST', uri);

  
    request.fields['nomePeca'] = nome;
    request.fields['descricao'] = descricao;
    request.fields['garantia'] = garantia;
    request.fields['fabricante'] = modelo;
    request.fields['qntd'] = qntd;
    final valor1 = valor.replaceAll(".", "");
    print(valor1);
    request.fields['preco'] = valor1;
    request.fields['VendedorId'] = vendId;
    
    final imagemStream = http.ByteStream(imagemFile.openRead());
    final imagemLength = await imagemFile.length();

    final multipartFile = http.MultipartFile(
      'imagem', 
      imagemStream,
      imagemLength,
      filename: p.basename(
        imagemFile.path.isNotEmpty ? imagemFile.path : 'default.jpg',
      ),
    );

    request.files.add(multipartFile);

    final client = createIgnoringCertificateClient();

    try {
      final streamedResponse = await client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201) {
        pecaCriada = true;
      } else {
        print('Erro ao criar peça. Código: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
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
      });
      print('Foto tirada da câmera: ${_imagemSelecionada?.path}');
      
    } else {
      print('Nenhuma foto tirada.');
    }
  }

  

  void _mostrarEscolhaImagem() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Anuncie uma peça',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(_nomePecaController, 'Nome da peça'),
                    const SizedBox(height: 14.0),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(_modeloController, 'Modelo'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      _quantidadeController,
                      'Quantidade a ser anunciada',
                      maxLength: 9,
                      keyboardType: TextInputType.numberWithOptions(signed: false,decimal: true),
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      _valorController,
                      'Valor da peça (R\$)',
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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
                    ],
                    const SizedBox(height: 24.0),
                    _buildOutlinedButton('Insira uma imagem', () {
                      setState(() {
                        _mostrarEscolhaImagem();
                      });
                    }),
                    const SizedBox(height: 16.0),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          
                          print(user.id);
                          
                          if (_imagemSelecionada != null) {
                            await enviarPecaComImagem(
                              context: context, 
                              nome: _nomePecaController.text,
                              descricao: _descricaoController.text,
                              imagemFile: _imagemSelecionada!,
                              garantia: _garantiaController.text,
                              qntd: _quantidadeController.text,
                              modelo: _modeloController.text,
                              valor: _valorController.text,
                              vendId: user.id,
                            );
                            if (pecaCriada) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Anuncio da peça cirado com sucesso!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.blue,
                                ),
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MenuPrincipal(),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Por favor, selecione uma imagem.',
                                ),
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
                          'Anunciar',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ],
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
    int? maxLength
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
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
