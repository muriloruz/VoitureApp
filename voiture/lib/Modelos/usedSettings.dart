import 'package:flutter/material.dart';
import 'package:voiture/login.dart';
import 'package:voiture/menuPrincipal.dart';

/* Classe para usar o Appbar e BottomNavBar para todas as telas*/


class UsedBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const UsedBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colors.black,
      elevation: 8,
      onTap: onTap,
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
