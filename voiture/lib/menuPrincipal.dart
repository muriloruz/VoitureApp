import 'dart:convert';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:voiture/PerfilVend.dart';
import 'package:voiture/anunciarPecas.dart';
import 'package:voiture/buscarUnicaPeca';
import 'package:voiture/perfilUser.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/todasPecas.dart';
/* - Classe menu, aparece depois de efetuar o login, ela tem os botões para anunciar peça, ver todas as peças e por ultimo ver os favoritos 
   - "Anunciar Peça" só funciona se a role do user for "vendedor";
   - Primeira aparição do AppBar e BottomBar pro usuario. 
*/
Usuario user = Usuario.instance;

Future<String> getToken() async {
  ReqResp r = ReqResp("https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient());
  final dcPaylod = r.decodeJwtToken(user.token);
  String resp = dcPaylod.toString();
  var priQuebra = resp.split(":");
  var segQuebra = priQuebra[1].split(",");
  try {
    final http.Response resposta =
        await r.getByName("usuario/single/", segQuebra[0].trim());
    Map<String, dynamic> jsonData = jsonDecode(resposta.body);
    String id = jsonData['id'];
    return id;
  } catch (err) {
    final http.Response resposta =
        await r.getByName("Vendedor/", segQuebra[0].trim());
    Map<String, dynamic> jsonData = jsonDecode(resposta.body);
    String id = jsonData['id'];
    return id;
  }
}

void getRoleUser() async {
  var id = await getToken();
  print(id);
  ReqResp r = ReqResp("https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient());
  final http.Response resp = await r.getByName("usuario/getRole/", id);
  print(resp.statusCode);
  print(resp.body.toString());
  Map<String, dynamic> jsonResponse = jsonDecode(resp.body.toString());
  var roles = jsonResponse['roles'][0];
  print(roles);
  user.role = roles;
}

void main() {
  runApp(const MenuPrincipal());
}

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

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

  void _escolherImagemGaleria() {
    print('Escolher imagem da galeria');
    // Implemente a lógica para escolher imagem da galeria
  }

  void _tirarFotoCamera() {
    print('Tirar foto da câmera');
    // Implemente a lógica para tirar foto da câmera
  }

  void _navigateToHome() {
    print('Navegar para a tela Início');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuPrincipal()), // Exemplo
    );
  }

  void _navigateToPedidos() {
    print('Navegar para a tela Pedidos');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => PedidosScreen()),
    // );
  }

  void _navigateToCarrinho() {
    print('Navegar para a tela Favoritos');
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FavoritosScreen()),
    // );
  }

  void _navigateToPerfil() {
    print('Navegar para a tela Perfil');
    if (user.role == 'USUARIO') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PerfilUser()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PerfilVend()));
    }
    print('Perfil pressionado');
  }

  @override
  Widget build(BuildContext context) {
    getRoleUser();
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "menu"),
      body: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300],
                  hintText: 'Buscar peças',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (String valorDigitado) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BuscarUnicaPeca(nomePeca: valorDigitado)));
                  // Aqui você pode chamar a função de busca com esse valor
                },
              ),
            ),
            const SizedBox(height: 16),
            Padding(padding: const EdgeInsets.fromLTRB(0, 20.0, 0, 0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,  MaterialPageRoute(builder: (context) => const BuscarTdsPeca()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.directions_car_filled_outlined,
                            color: Colors.black),
                        SizedBox(width: 16),
                        Text('Todas as peças',
                            style: TextStyle(color: Colors.black)),
                          
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    if (user.role == 'USUARIO') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Você não tem acesso a essa função."),
                          content: const Text(
                              "Apenas usuários vendedores podem criar anúncios de peças."),
                          actions: [
                            TextButton(
                              child: const Text('Ok'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      );
                    }
                    if (user.role == 'VENDEDOR') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnunciarPeca()),
                      );
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.attach_money_outlined, color: Colors.black),
                        SizedBox(width: 16),
                        Text('Anunciar peças',
                            style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    print('Favoritos pressionado');
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.star_outlined, color: Colors.black),
                        SizedBox(width: 16),
                        Text('Favoritos', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
          ],
        ),
      ),
      ), 
      
      bottomNavigationBar: uS.UsedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}