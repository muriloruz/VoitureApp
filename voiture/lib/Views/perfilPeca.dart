import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/peca.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/Views/menuPrincipal.dart';
import 'package:voiture/Views/pagamento.dart';
import 'package:http/http.dart' as http;
import 'package:voiture/Modelos/carrinho.dart' as car;


class PerfilPeca extends StatefulWidget {
  final int idPeca; 
  const PerfilPeca({Key? key, required this.idPeca}) : super(key: key);

  @override
  State<PerfilPeca> createState() => _PerfilPecaState();
}

class _PerfilPecaState extends State<PerfilPeca> {
  
  String _nomePeca = 'Radiador Denso BC116420-45802C';
  double _preco = 399.00;
  String _descricao =
      'Descrição: Radiador compatível com Gol G5, alta eficiência térmica, ideal para reposição rápida.';
  String _fabricante = 'ThermoMax';
  String _garantia = 'Garantia: 12 meses';
  String _vendedor = 'Vendedor: Jacinto Pinto';
  String _emailVendedor = 'jacinto.pinto@email.com'; 
  String _telefoneVendedor = '(11) 98765-4321'; 
  String _imagemUrl =
      'https://192.168.94.220:7101/imagens/1000100451.jpg'; 
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _carregarDadosPeca(); 
  }

  Future<void> _carregarDadosPeca() async {
    
    await Future.delayed(const Duration(seconds: 2));
    ReqResp r = new ReqResp(
      "https://192.168.94.220:7101",
      httpClient: createIgnoringCertificateClient(),
    );
    try {
      http.Response resp = await r.getById("peca/", widget.idPeca);
      if (resp.statusCode == 200) {
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
        print('Erro ao carregar dados da peça: ${resp.statusCode}');
      }
    } catch (e) {
      print('Erro na requisição: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "perfilPeca"),
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
            Row(
              children: [
                Text(
                  '1x R\$ ${_preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const Spacer(),
                IconButton(
                  iconSize: 20.0,
                  splashRadius: 20.0,
                  tooltip: _isFavorited ? 'Desfavoritar' : 'Favoritar',
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    setState(() {
                      if (_isFavorited == false) {
                        _isFavorited = true;
                      } else {
                        _isFavorited = true;
                      }
                    });
                    if (_isFavorited == true && user.role != 'VENDEDOR') {
                      ReqResp r = new ReqResp(
                        "https://192.168.94.220:7101",
                        httpClient: createIgnoringCertificateClient(),
                      );
                      Map<String, dynamic> body = {
                        "userId": user.id,
                        "pecaId": widget.idPeca,
                      };
                      http.Response resp = await r.post("favorito", body);
                      if (resp.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Peça já favoritada previamente'),
                          ),
                        );
                      }
                      if (resp.statusCode == 201) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Peça adicionada aos favoritos!',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                      }
                      print(resp.body);
                      print(resp.statusCode);
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext ctx) {
                          return AlertDialog(
                            title: const Text('ERRO 35'),
                            content: const Text(
                              'Vendedores não podem favoritar nem comprar peças',
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    print('Favorito: $_isFavorited');
                  },
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            SizedBox(
              width: double.infinity,
              child: Image.network(
                'https://192.168.94.220:7101/imagens/$_imagemUrl',
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
                      if (user.role == 'VENDEDOR') {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext ctx) {
                            return AlertDialog(
                              title: const Text('ERRO 35'),
                              content: const Text(
                                'Vendedores não podem favoritar nem comprar peças',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Pagamento(
                                  idPeca: widget.idPeca,
                                  numeroPecas: 1,
                                ),
                          ),
                        );
                      }
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
                      Peca p = new Peca(nome: _nomePeca,descricao: _descricao,garantia: _garantia,imagemFile: _imagemUrl
                      ,modelo: _fabricante,valor: _preco,vendId: _vendedor, id: widget.idPeca );
                      car.Carrinho  c =  car.Carrinho.instance;
                      c.adicionarPeca(p);
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
      bottomNavigationBar: uS.UsedBottomNavigationBar(), 
    );
  }
}