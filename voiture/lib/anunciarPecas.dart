import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/PerfilVend.dart';
import 'package:voiture/menuPrincipal.dart';
import 'package:voiture/perfilUser.dart';
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
class AnunciarPeca extends StatefulWidget {
  
  const AnunciarPeca({super.key});

  @override
  State<AnunciarPeca> createState() => _AnunciarPecaScreenState();
}

class _AnunciarPecaScreenState extends State<AnunciarPeca> {
  final TextEditingController _nomePecaController = TextEditingController();
  final TextEditingController _modeloController = TextEditingController();
  final TextEditingController _anoController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _garantiaController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  File? _imagemSelecionada; // Variável para armazenar a imagem selecionada
  final ImagePicker _picker = ImagePicker();
  bool _mostrarOpcoesImagem = false;
  bool pecaCriada = false;


  int _selectedIndex = 0;

  
Future<void> enviarPecaComImagem({
  required BuildContext context,
  required String nome,
  required String descricao,
  required String modelo,
  required String qntd,
  required String valor,
  required String garantia,
  required File imagemFile,
  required String vendId
}) async {
  final uri = Uri.parse("https://192.168.18.61:7101/peca");

  final request = http.MultipartRequest('POST', uri);

  // Campos de texto
  request.fields['nomePeca'] = nome;
  request.fields['descricao'] = descricao;
  request.fields['garantia'] = garantia;
  request.fields['fabricante'] = modelo;
  request.fields['qntd'] = qntd;
  request.fields['valor'] = valor;
  request.fields['VendedorId'] = vendId;
  // Arquivo da imagem
  final imagemStream = http.ByteStream(imagemFile.openRead());
  final imagemLength = await imagemFile.length();

  final multipartFile = http.MultipartFile(
    'imagem', // nome do campo esperado no backend
    imagemStream,
    imagemLength,
    filename: p.basename(imagemFile.path.isNotEmpty ? imagemFile.path : 'default.jpg'),
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
    client.close(); // importante!
  }
}


  Future<void> _escolherImagemGaleria() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
      print('Imagem selecionada da galeria: ${_imagemSelecionada?.path}');
      // Aqui você pode fazer algo com a imagem selecionada, como exibir ou fazer upload.
    } else {
      print('Nenhuma imagem selecionada.');
    }
  }

  // Função para tirar uma foto com a câmera
  Future<void> _tirarFotoCamera() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
      });
      print('Foto tirada da câmera: ${_imagemSelecionada?.path}');
      // Aqui você pode fazer algo com a foto tirada.
    } else {
      print('Nenhuma foto tirada.');
    }
  }


  void _onItemTapped(int index) {
    setState(() {
        _selectedIndex = index;
        switch (index) {
        case 0: // Início
          _navigateToHome();
          break;
        case 1: // Pedidos
          _navigateToPedidos();
          break;
        case 2: // Favoritos
          _navigateToCarrinho();
          break;
        case 3: // Perfil
          _navigateToPerfil();
          break;
     }
    });
    
    
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
            Navigator.of(context).pop(); // Fecha o alerta
            _escolherImagemGaleria();
          },
          child: const Text('Galeria'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fecha o alerta
            _tirarFotoCamera();
          },
          child: const Text('Câmera'),
        ),
      ],
    ),
  );
}
  void _navigateToHome() {
  print('Navegar para a tela Início');
  // Aqui você pode navegar para a tela "Início"
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MenuPrincipal()), // Exemplo de navegação
  );
}


void _navigateToPedidos() {
  print('Navegar para a tela Pedidos');
  // Navegar para a tela "Pedidos"
  /*Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => PedidosScreen()),
  );*/
}


void _navigateToCarrinho() {
  print('Navegar para a tela Favoritos');
  // Navegar para a tela "Favoritos"
  /*Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => FavoritosScreen()),
  );*/
}



void _navigateToPerfil() {
  print('Navegar para a tela Perfil');
  if(user.role == 'USUARIO'){
    Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const PerfilUser())
    );
    }
    else{
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PerfilVend())
        );
    }
      print('Perfil pressionado');
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
                        Expanded(child: _buildTextField(_modeloController, 'Modelo')),
                        
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      _quantidadeController,
                      'Quantidade a ser anunciada',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      _valorController,
                      'Valor da peça (R\$)',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
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
                          context: context, // Passe o context aqui
                          nome: _nomePecaController.text,
                          descricao: _descricaoController.text,
                          imagemFile: _imagemSelecionada!,
                          garantia: _garantiaController.text,
                          qntd: _quantidadeController.text,
                          modelo: _modeloController.text,
                          valor: _valorController.text,
                          vendId: user.id,
                        );
                        if(pecaCriada){
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Anuncio da peça cirado com sucesso!',style: TextStyle(color: Colors.white)),backgroundColor: Colors.blue, ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const MenuPrincipal())
                          );
                        }
                      } else {
                        // Lidar com o caso em que nenhuma imagem foi selecionada
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Por favor, selecione uma imagem.')),
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
                        child: const Text('Anunciar', style: TextStyle(fontSize: 16.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
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

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black,
      elevation: 8,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, 
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_outlined),
          label: 'Pedidos',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Carrinho',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }

}

