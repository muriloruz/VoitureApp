import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:voiture/Views/perfilPedidos.dart';
import 'package:voiture/Modelos/usuario.dart';

class PedidosScreen extends StatefulWidget {
  const PedidosScreen({Key? key}) : super(key: key);

  @override
  State<PedidosScreen> createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  List<dynamic> _pecas = [];
  bool _isLoading = true;
  String? _errorMessage;
  final TextEditingController _searchController = TextEditingController();
  Usuario user = Usuario.instance;

  @override
  void initState() {
    super.initState();
    _fetchPedidos();
  }
  Future<void>_buscarPecasPorNome(String nome) async {
      try {
        ReqResp r = ReqResp(
          "https://192.168.18.61:7101",
          httpClient: createIgnoringCertificateClient(),
        );

        final response = await r.get("VendedorCliente/pecas/$nome");

        if (response.statusCode == 200) {
          final decoded = json.decode(response.body);
          setState(() {
            _pecas = decoded is List ? decoded : [decoded];
            _errorMessage = null;
          });
        } else if (response.statusCode == 404) {
          setState(() {
            _pecas = [];
            _errorMessage = 'Nenhuma peça encontrada';
          });
        } else {
          setState(() {
            _errorMessage = 'Erro ao buscar: ${response.statusCode}';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Erro ao buscar: $e';
        });
      }
    }
  Future<void> _fetchPedidos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      ReqResp r = new ReqResp(
        "https://192.168.18.61:7101",
        httpClient: createIgnoringCertificateClient(),
      );
      http.Response response = await r.getByName("VendedorCliente/", user.id);
      if (user.role == 'VENDEDOR') {
        setState(() {
          _errorMessage = 'Vendedores não possuem historico de compras';
        });
      } else {
        if (response.statusCode == 200) {
          final dynamic decodedData = json.decode(response.body);
          if (decodedData is List) {
            _pecas = decodedData;
            print("foi aqui");
          } else if (decodedData is Map<String, dynamic>) {
            print("foi aqui 222");
            _pecas = [decodedData];
          }

          setState(() {});
        } else {
          setState(() {
            _errorMessage =
                'Falha ao carregar pedidos. Status: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro de conexão: $e';
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
      appBar: uS.UsedAppBar(nome: "perfil"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Buscar pedido',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                ),
                onSubmitted: (query) {
                  if (query.isEmpty) {
                    _fetchPedidos(); 
                  } else {
                    final value = Uri.encodeComponent(query);
                    _buscarPecasPorNome(value); 
                  }
                },
              ),
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(child: Text(_errorMessage!))
                    : _pecas.isEmpty
                    ? const Center(
                      child: Text(
                        'Você ainda não realizou um pedido.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _pecas.length,
                      itemBuilder: (context, index) {
                        final peca = _pecas[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              print(peca['peca']['id']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PerfilPedidos(
                                        idPeca: peca['peca']['id'],
                                      ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (peca['peca']['imagem'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16.0,
                                      ),
                                      child: SizedBox(
                                        width: 100,
                                        height: 120,
                                        child: Image.network(
                                          'https://192.168.18.61:7101/imagens/${peca['peca']['imagem']}',
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) {
                                            return const Icon(
                                              Icons.image_not_supported,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          peca['peca']['nomePeca'] ??
                                              'Nome Indisponível',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Descrição: ${peca['peca']['descricao'] ?? 'Indisponível'}',
                                        ),
                                        Text(
                                          'Preço: ${(peca['peca']['preco'] ?? 0.0).toStringAsFixed(2)}',
                                        ),
                                        Text(
                                          'Garantia: ${peca['peca']['garantia'] ?? 'Não Informada'}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
    );
  }
}
