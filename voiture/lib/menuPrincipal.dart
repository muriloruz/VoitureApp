import 'package:flutter/material.dart';
import 'package:voiture/login.dart';
import 'package:voiture/perfilUser.dart';

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
        // *** CORES DO APP (TEMA GERAL) ***
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

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Colors.black, // Cor da AppBar
        toolbarHeight: 160.0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // Cor do ícone de voltar
          ),
          onPressed: () {
            // Ação ao pressionar o botão de voltar
            MaterialPageRoute(builder: (context) => const Login());
          },
        ),
        
        title: Center(
          child: Image.asset(
            'assets/voiturelogo.jpg', // Caminho para o logo (substitua pelo seu)
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        actions: const [
          SizedBox(width: 48), // Espaço para alinhar o título ao centro
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            // *** BARRA DE PESQUISA ***
            Padding(
              padding:const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[300], // Cor de fundo da barra de pesquisa
                  hintText: 'Buscar peças',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () {
                  // Ação ao tocar na barra de pesquisa
                  print('Buscar peças tocado');
                },
              ),
            ),
            const SizedBox(height: 16),
            // *** BOTÕES SUPERIORES COM BORDA ***
            Padding(padding: EdgeInsets.fromLTRB(0, 20.0, 0, 0)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child:DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Cor da borda
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: InkWell(
                  onTap: () {
                    // Ação ao pressionar "Selecionar veículo"
                    print('Selecionar veículo pressionado');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: const [
                        Icon(Icons.directions_car_filled_outlined, color: Colors.black),
                        SizedBox(width: 16),
                        Text('Todas as peças', style: TextStyle(color: Colors.black)),
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
                border: Border.all(color: Colors.black), // Cor da borda
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  // Ação ao pressionar "Anunciar peças"
                  print('Anunciar peças pressionado');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Icon(Icons.attach_money_outlined, color: Colors.black),
                      SizedBox(width: 16),
                      Text('Anunciar peças', style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(padding: const EdgeInsets.all(16.0),
            child:DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[700]!), // Cor da borda
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: InkWell(
                onTap: () {
                  // Ação ao pressionar "Favoritos"
                  print('Favoritos pressionado');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: const [
                      Icon(Icons.star_outlined, color: Colors.black),
                      SizedBox(width: 16),
                      Text('Favoritos', style: TextStyle(color: Colors.black)),
                    ],
                    ),
                  ),
                ),
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
                      // Ação ao pressionar "Menu"
                      print('Menu pressionado');
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