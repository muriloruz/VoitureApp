import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/PerfilVend.dart';
import 'package:voiture/menuPrincipal.dart';
import 'package:voiture/pagamento.dart';
import 'package:voiture/perfilUser.dart';
import 'package:http/http.dart' as http;

class PerfilPeca extends StatefulWidget {
  final int idPeca; // Exemplo de como você pode passar o ID da peça
  const PerfilPeca({Key? key, required this.idPeca}) : super(key: key);

  @override
  State<PerfilPeca> createState() => _PerfilPecaState();
}

class _PerfilPecaState extends State<PerfilPeca> {
  // Dados que serão buscados da API
  String _nomePeca = 'Radiador Denso BC116420-45802C';
  double _preco = 399.00;
  String _descricao =
      'Descrição: Radiador compatível com Gol G5, alta eficiência térmica, ideal para reposição rápida.';
  String _fabricante = 'ThermoMax';
  String _garantia = 'Garantia: 12 meses';
  String _vendedor = 'Vendedor: Jacinto Pinto';
  String _emailVendedor = 'jacinto.pinto@email.com'; // Exemplo de email
  String _telefoneVendedor = '(11) 98765-4321'; // Exemplo de telefone
  String _imagemUrl =
      'https://192.168.18.61:7101/imagens/1000100451.jpg'; // URL da imagem (substitua pela sua)

  @override
  void initState() {
    super.initState();
    _carregarDadosPeca(); // Chamando a função para buscar os dados da API
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          print('Navegar para a tela Início');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MenuPrincipal(),
            ), // Exemplo
          );
          break;
        case 1:
          // Navegar para a tela de pedidos
          break;
        case 2:
          // Navegar para a tela de carrinho
          break;
        case 3:
          print('Navegar para a tela Perfil');
          if (user.role == 'USUARIO') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilUser()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilVend()),
            );
          }
          print('Perfil pressionado');
          break;
      }
    });
  }

  Future<void> _carregarDadosPeca() async {
    // Simulação de chamada à API (substitua pela sua lógica real)
    await Future.delayed(const Duration(seconds: 2));
    ReqResp r = new ReqResp(
      "https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient(),
    );
    try {
      http.Response resp = await r.getById("peca/", widget.idPeca);
      if (resp.statusCode == 200) {
        // Processar a resposta da API e atualizar o estado
        Map<String, dynamic> data = jsonDecode(resp.body);
        setState(() {
          _nomePeca = data['nomePeca'];
          _preco = data['preco'];
          _descricao = data['descricao'];
          _fabricante = data['fabricante'];
          _garantia = data['garantia'];
          _vendedor = data['vendedorNome'];
          _emailVendedor = data['vendedorEmail'];
          _telefoneVendedor = data['vendedorTelefone'];
          _imagemUrl = data['imagem'];
        });
      } else {
        // Lidar com erros na chamada da API
        print('Erro ao carregar dados da peça: ${resp.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "perfil"), // Usando a AppBar personalizada
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '$_nomePeca',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              '1x R\$ ${_preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Image.network(
                'https://192.168.18.61:7101/imagens/$_imagemUrl',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Descrição ',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _descricao,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Fabricante: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _fabricante,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Garantia: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _garantia,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Vendedor: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _vendedor,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Email: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _emailVendedor,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'Telefone: ',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    _telefoneVendedor,
                    style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onPressed: () {
                      // Lógica para comprar agora
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Pagamento(idPeca: widget.idPeca, numeroPecas: 1)));
                    },
                    child: const Text(
                      'Comprar agora',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: const BorderSide(color: Colors.black),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                    ),
                    onPressed: () {
                      // Lógica para adicionar ao carrinho
                      print('Adicionar ao carrinho pressionado');
                    },
                    child: const Text(
                      'Adicionar ao carrinho',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ), // Usando a BottomNavigationBar personalizada
    );
  }
}
