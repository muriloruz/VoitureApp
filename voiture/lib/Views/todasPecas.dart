import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:http/http.dart' as http;
import 'package:voiture/Views/buscarUnicaPeca.dart';
import 'dart:convert';
import 'package:voiture/Views/perfilPeca.dart';
/*
  Classe que exibe todas as peças, do tipo StateFul(Ver classe buscarUnicaPeca), usada para mudar quando o user abri-lá e aparecer as peças
 */

class BuscarTdsPeca extends StatefulWidget {
  const BuscarTdsPeca({super.key});

  @override
  State<BuscarTdsPeca> createState() => _BuscarTdsPecaState();
}

class _BuscarTdsPecaState extends State<BuscarTdsPeca> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _pecas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> _buscarTodasPecas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _pecas = [];
    });
    const String url = 'https://192.168.18.61:7101';
    ReqResp r = ReqResp(url, httpClient: createIgnoringCertificateClient());
    try {
      final http.Response response = await r.get("peca");
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _pecas = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao buscar peças: ${response.statusCode}';
          _isLoading = false;
        });
        print('Erro ao buscar peças: ${response.statusCode}');
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Erro de conexão: $error';
        _isLoading = false;
      });
      print('Erro de conexão: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _buscarTodasPecas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "tdsP"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar peça',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (valorDigitado) {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                BuscarUnicaPeca(nomePeca: valorDigitado),
                      ),
                    );
              },
            ),
          ),
          Expanded(
            child:
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : ListView.builder(
                      itemCount: _pecas.length,
                      itemBuilder: (context, index) {
                        final peca = _pecas[index];
                        print(
                          'Nome do arquivo da imagem da API: ${peca['imagem']}',
                        );
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPeca(idPeca: peca['id'])));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,

                                    child: Image.network(
                                      'https://192.168.18.61:7101/imagens/${peca['imagem']}',
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
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          peca['nomePeca'] ??
                                              'Nome Indisponível',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          peca['descricao'] ??
                                              'Descrição Indisponível',
                                        ),
                                        Text((peca['preco'] ?? 0.0).toString()),
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
