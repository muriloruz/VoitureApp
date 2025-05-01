import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/menuPrincipal.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as io;

String globalNome = '';
String globalEmail = '';
String globalCelular = '';
String globalCpf = '';
final Usuario user = Usuario.instance;




void _FazerReq() async{
  ReqResp r = new ReqResp("https://192.168.18.61:7101",httpClient: createIgnoringCertificateClient());
  final dcPaylod = r.decodeJwtToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjAxNTdlYTMzLTE2ZTQtNGZlNC1iYzA0LWVkY2UzZDkxNmVhYyIsInVzZXJuYW1lIjoibXVyaWxvcnV6NjRAZ21haWwuY29tIiwibm9tZSI6Im11bGlybyIsImV4cCI6MTc0NjU2MjY0MH0.sRTzaW-aIOBWGAkKTc_KSVeXy6s96XPcW4rOIBYAYVI");
  //final dcPaylod = r.decodeJwtToken(user.token);
  String resp = dcPaylod.toString();
  var priQuebra = resp.split(":");
  var segQuebra = priQuebra[1].split(",");
  final http.Response resposta = await r.getByName("usuario/single/",segQuebra[0].trim());
  print(resposta.body);

}

void main() {
  runApp(const PerfilUser());
}

class PerfilUser extends StatelessWidget {
  const PerfilUser({super.key});
  

  @override
  Widget build(BuildContext context) {
    // *** CORES DO APP ***
    _FazerReq();
    const Color backgroundColor = Color(0xFFFFFFFF);
    const Color primaryTextColor = Colors.black;
    const Color secondaryTextColor = Colors.black;
    const Color inputBackgroundColor = Color(0xFFE0E0E0);
    const Color buttonBackgroundColor = Colors.black;
    const Color buttonTextColor = Colors.white;
    const Color appBarIconColor = Colors.white;
    
    return MaterialApp(
      title: 'Tela de perfil vendedor',
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: backgroundColor),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: primaryTextColor),
          bodySmall: TextStyle(color: secondaryTextColor),
          titleMedium: TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBackgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: secondaryTextColor),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonBackgroundColor,
            foregroundColor: buttonTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: buttonBackgroundColor,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor,
          iconTheme: IconThemeData(color: appBarIconColor),
          titleTextStyle: TextStyle(color: primaryTextColor, fontSize: 18.0),
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 107.0,
        
        title: Center(
          child: Transform.translate(
            offset: const Offset(19.0, 0.0),
            child:Image.asset('assets/voiturelogo.jpg',
            width: 110,
            height: 110,
            )
            
          ),
          
        ),
        actions: const [
          SizedBox(width: 40), // Espaço para centralizar o título
        ],
      ),
      
      body: Padding(
        
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [
          const SizedBox(height: 10.0),

            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person_outline,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      
                    ),
                  ),
                ],
              ),
            ),





            const SizedBox(height: 24.0),
            Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start, // Alinha os textos à esquerda
    children: [
      Text('Nome', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity, // Ocupa toda a largura disponível
        height: 50.0, // Altura fixa para simular o tamanho de uma imagem
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'Jorge Peças',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 16.0),
      Text('E-mail', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        height: 50.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          'jorgePeças@gmail.com',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 16.0),
      Text('Celular', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        height: 50.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          '(11) 91234-5678',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 16.0),
      Text('CPF', style: Theme.of(context).textTheme.bodySmall),
      const SizedBox(height: 8.0),
      Container(
        width: double.infinity,
        height: 50.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Text(
          '12.345.678/0000-00',
          style: TextStyle(color: Colors.black),
        ),
      ),
      const SizedBox(height: 15.0),
      Row(
        children: [
          Center(
            child: Transform.translate(
            offset: const Offset(110.0, 0.0),
          child:Expanded(
            child: ElevatedButton(
              onPressed: () {
                // Ação ao salvar
              },
              child: const Text('Alterar dados'),
            ),
            
          ),
          
          ),
          
          )
        ],
      ),
        ],
      ),
      ),
            const Spacer(), // Empurra a barra de navegação para baixo
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Botões de navegação
                  
                  TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuPrincipal())
                      );
                    },
                    icon: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.home_outlined, color: Colors.black),
                        Text('Menu', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    label: const SizedBox.shrink(),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Ação ao pressionar "Pedidos"
                      print('Pedidos pressionado');
                    },
                    icon: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt_outlined, color: Colors.black),
                        Text('Pedidos', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    label: const SizedBox.shrink(),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Ação ao pressionar "Carrinho"
                      print('Carrinho pressionado');
                    },
                    icon: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: Colors.black),
                        Text('Carrinho', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    label: const SizedBox.shrink(),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PerfilUser())
                        );
                        print('Perfil pressionado');
                      },
                      icon: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Icon(Icons.person, color: Colors.black),
                      Text('Perfil', style: TextStyle(color: Colors.black)),
                      ],
                    ),
                    label: const SizedBox.shrink(),
                  )
                ],
              ),
            )
          ],
          
        ),
      ),
      
    );
  }
}