import 'package:flutter/material.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:voiture/Views/perfilPeca.dart';


/*
 - Tela que aparece quando o usuário pesquisa uma peça
 - Note que ela é uma classe Stateful, esse tipo de classe serve para usar um tipo de estado chamado "mutável";
 - Estados mutável é um tipo de classe que pode mudar durante a execução da mesma.
 */
class BuscarUnicaPeca extends StatefulWidget {
  final String nomePeca;

  const BuscarUnicaPeca({super.key, required this.nomePeca});

  @override
  State<BuscarUnicaPeca> createState() => _BuscarUnicaPecaState();
}

class _BuscarUnicaPecaState extends State<BuscarUnicaPeca> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _pecas = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _buscarPecas(widget.nomePeca);
  }

  Future<void> _buscarPecas(String termoBusca) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _pecas = [];
    });

    final String url = 'https://192.168.53.220:7101/peca/$termoBusca';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dynamic data = jsonDecode(response.body);
        setState(() {
          if (data is List) {
            _pecas = data;
          } else if (data is Map<String, dynamic>) {
            _pecas = [data];
          } else {
            _errorMessage = 'Resposta da API em formato inesperado.';
          }
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _errorMessage = 'Peça "${widget.nomePeca}" não encontrada.';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao buscar peça: ${response.statusCode}';
          _isLoading = false;
        });
        print('Erro ao buscar peça: ${response.statusCode}');
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "pop"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar outra peça',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                final query = Uri.encodeComponent(value);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BuscarUnicaPeca(nomePeca: query),
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
                    : _pecas.isNotEmpty
                    ? ListView.builder(
                      itemCount: _pecas.length,
                      itemBuilder: (context, index) {
                        final peca = _pecas[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          PerfilPeca(idPeca: peca['id']),
                                ),
                              );
                            },

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (peca['imagem'] != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16.0,
                                      ),
                                      child: SizedBox(
                                        width: 100,
                                        height: 120,
                                        child: Image.network(
                                          'https://192.168.53.220:7101/imagens/${peca['imagem']}',
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
                                          peca['nomePeca'] ??
                                              'Nome Indisponível',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Descrição: ${peca['descricao'] ?? 'Indisponível'}',
                                        ),
                                        Text(
                                          'Preço: ${(peca['preco'] ?? 0.0).toStringAsFixed(2)}',
                                        ),
                                        Text(
                                          'Fabricante: ${peca['fabricante'] ?? 'Não Informado'}',
                                        ),
                                        Text(
                                          'Garantia: ${peca['garantia'] ?? 'Não Informada'}',
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
                    )
                    : const Center(child: Text('Nenhuma peça encontrada.')),
          ),
        ],
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
    );
  }
}
