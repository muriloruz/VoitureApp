import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'dart:convert';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/Views/atualizarPeca.dart' as a;
import 'package:voiture/Views/menuPrincipal.dart';

class AlterarPecas extends StatefulWidget {
  @override
  _AlterarPecasState createState() => _AlterarPecasState();
}

class _AlterarPecasState extends State<AlterarPecas> {
  List<dynamic> _pecas = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _buscarPecas();
  }

  Future<void> _buscarPecas() async {
  setState(() => _isLoading = true);
  final r = ReqResp(
    "https://192.168.18.61:7101",
    httpClient: createIgnoringCertificateClient(),
  );

  try {
    final resp = await r.getByName("Vendedor/", user.id);
    print("${resp.statusCode}");
    final dynamic decodedData = json.decode(resp.body);

    if (decodedData is Map<String, dynamic>) {
      final pecas = decodedData['pecas'];
      if (pecas != null && pecas is List) {
        setState(() {
          _pecas = pecas;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _pecas = [];
          _errorMessage = 'Nenhuma peça encontrada.';
        });
      }
    } else {
      setState(() => _errorMessage = 'Resposta inesperada do servidor');
    }
  } catch (e) {
    setState(() => _errorMessage = 'Erro de conexão: $e');
    print(e);
  } finally {
    setState(() => _isLoading = false);
  }
}

  void _removerItem(int id) {
    setState(() {
      _pecas.removeWhere((item) => item['id'] == id);
      if (_pecas.isEmpty) _errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: uS.UsedAppBar(nome: 'Editar Perfil'),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _pecas.isEmpty
                  ? const Center(
                      child: Text(
                        'Sem peças cadastradas',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _pecas.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      itemBuilder: (context, i) {
                        final p = _pecas[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => a.AtualizarPeca(idPeca: p['id']),
                              ),
                            ),
                            child: ListTile(
                              leading: SizedBox(
                                width: 80,
                                height: 80,
                                child: Image.network(
                                  'https://192.168.18.61:7101/imagens/${p['imagem']}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.image_not_supported),
                                ),
                              ),
                              title: Text(
                                p['nomePeca'] ?? 'Nome Indisponível',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['descricao'] ?? 'Descrição Indisponível'),
                                  Text('Preço: R\$ ${p['preco'].toStringAsFixed(2)}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  final r2 = ReqResp(
                                    'https://192.168.18.61:7101',
                                    httpClient: createIgnoringCertificateClient(),
                                  );
                                  await r2.delete("peca/apagar", p['id']);
                                  _removerItem(p['id']);
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
