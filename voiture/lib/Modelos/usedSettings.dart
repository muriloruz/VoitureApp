import 'package:flutter/material.dart';
import 'package:voiture/Views/PerfilVend.dart';
import 'package:voiture/Views/carrinhoScreen.dart';
import 'package:voiture/Views/login.dart';
import 'package:voiture/Views/menuPrincipal.dart';
import 'package:voiture/Views/pedidos.dart';
import 'package:voiture/Views/perfilUser.dart';
import 'package:voiture/Views/todasPecas.dart';
import 'package:voiture/Modelos/usuario.dart';

/* Classe para usar o Appbar e BottomNavBar para todas as telas, modelo para implementação mais de uma vez*/


class UsedBottomNavigationBar extends StatefulWidget {
  const UsedBottomNavigationBar({super.key});

  @override
  State<UsedBottomNavigationBar> createState() => _MyBottomNavBarScreenState();
}

class _MyBottomNavBarScreenState extends State<UsedBottomNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Usuario user = Usuario.instance;

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PedidosScreen()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CarrinhoScreen()),
        );
        break;
      case 3:
        if (user.role == 'USUARIO') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PerfilUser()),
          );
        } else if (user.role == 'VENDEDOR') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PerfilVend()),
          );
        } else {
          print('Role do usuário desconhecida: ${user.role}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
class UsedAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String nome;
  const UsedAppBar({super.key,
  required this.nome});

   @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      toolbarHeight: 160.0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () {
          if(nome == "perfil") {Navigator.push(context, MaterialPageRoute(builder: (context) => MenuPrincipal()));}
          else if(nome == "menu") {Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));}
          else if(nome == "peca"){Navigator.push(context, MaterialPageRoute(builder: (context) => BuscarTdsPeca()));}
          else if( nome == "Editar Perfil"){
            Usuario user = Usuario.instance;
            if(user.role == 'USUARIO') {Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilUser()));}
            else {Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilVend()));}
          }
          else {Navigator.pop(context);}
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
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(160.0);
}
