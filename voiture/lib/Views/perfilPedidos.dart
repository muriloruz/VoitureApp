import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:http/http.dart' as http;

class CurrentUser {
  String? id;
  String? role;
}
CurrentUser user = CurrentUser();

class PerfilPedidos extends StatefulWidget {
  final int idPeca;
  const PerfilPedidos({Key? key, required this.idPeca}) : super(key: key);

  @override
  State<PerfilPedidos> createState() => _PerfilPedidosState();
}

class _PerfilPedidosState extends State<PerfilPedidos> {
  String _nomePeca = 'Carregando...';
  double _preco = 0.00;
  String _descricao = 'Carregando descrição...';
  String _fabricante = 'Carregando fabricante...';
  String _garantia = 'Carregando garantia...';
  String _vendedor = 'Carregando vendedor...';
  String _emailVendedor = 'Carregando email...';
  String _telefoneVendedor = 'Carregando telefone...';
  String _imagemUrl = 'https://via.placeholder.com/150';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    user.role = 'USUARIO';
    user.id = 'some-user-id';
    _carregarDadosPeca();
  }

  Future<void> _carregarDadosPeca() async {
    setState(() {
      _isLoading = true;
    });
    ReqResp r = ReqResp(
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
        setState(() {
          _nomePeca = 'Erro ao carregar';
          _descricao = 'Não foi possível carregar os detalhes da peça.';
        });
      }
    } catch (e) {
      print('Erro na requisição: $e');
      setState(() {
        _nomePeca = 'Erro de Conexão';
        _descricao = 'Verifique sua conexão e tente novamente.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "Detalhes do Pedido"),
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _nomePeca,
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
                        const Text(
                          'Descrição',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _descricao,
                          style: const TextStyle(fontSize: 18.0, color: Colors.grey),
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
                        const Text(
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
                        const Text(
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
                        const Text(
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
                        const Text(
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
                        const Text(
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
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Voltar',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
    );
  }
}