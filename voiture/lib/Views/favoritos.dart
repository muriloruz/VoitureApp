import 'package:flutter/material.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'dart:convert';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/menuPrincipal.dart';
import 'package:voiture/perfilPeca.dart';


class FavoritosScreen extends StatefulWidget {
  @override
  _FavoritosScreenState createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  List<dynamic> _pecasFavoritas = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _buscarPecasFavoritas();
  }

  Future<void> _buscarPecasFavoritas() async {
    setState(() => _isLoading = true);
    ReqResp r = new ReqResp(
      "https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient(),
    );
    try {
      final resp = await r.getByName("favorito/", user.id);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as List<dynamic>;
        setState(() => _pecasFavoritas = data);
      } else if (user.role == 'VENDEDOR') {
        setState(() => _errorMessage = 'Vendedores não podem favoritar peças');
      } else if (resp.statusCode == 404) {
        setState(() => _errorMessage = 'Nenhuma peça favoritada');
      } else {
        setState(() => _errorMessage = 'Erro ao buscar: ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Erro de conexão: $e');
      
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _removerItem(int id) {
    setState(() {
      _pecasFavoritas.removeWhere((item) => item['id'] == id);
      if (_pecasFavoritas.isEmpty) _errorMessage = null;
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: uS.UsedAppBar(nome: 'Favoritos'),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
              : _pecasFavoritas.isEmpty
              ? const Center(
                child: Text(
                  'Sem peças favoritadas',
                  style: TextStyle(fontSize: 18.0),
                ),
              )
              : ListView.builder(
                itemCount: _pecasFavoritas.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, i) {
                  final p = _pecasFavoritas[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: InkWell(
                      onTap: () => {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPeca(idPeca: p['id'])))
                      },
                      child: ListTile(
                        leading: SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.network(
                            'https://192.168.18.61:7101/imagens/${p['imagem']}',
                            fit: BoxFit.cover,
                            errorBuilder:
                                (_, __, ___) =>
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
                            final client2 = createIgnoringCertificateClient();
                            final r2 = ReqResp(
                              'https://192.168.18.61:7101',
                              httpClient: client2,
                            );
                            await r2.delete("favorito", p['id']);
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
