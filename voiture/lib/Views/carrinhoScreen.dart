import 'package:flutter/material.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/Modelos/carrinho.dart' as car;
import 'package:voiture/Modelos/peca.dart';
import 'package:voiture/Views/perfilPeca.dart';
import 'package:voiture/Modelos/usuario.dart';

Usuario user = Usuario.instance;

class CarrinhoScreen extends StatefulWidget {
  const CarrinhoScreen({Key? key}) : super(key: key);

  @override
  State<CarrinhoScreen> createState() => _CarrinhoScreenState();
}

class _CarrinhoScreenState extends State<CarrinhoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Peca> _filteredPecas = [];

  @override
  void initState() {
    super.initState();
    _filteredPecas = car.Carrinho.instance.itens;
    _searchController.addListener(_filterPecas);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterPecas);
    _searchController.dispose();
    super.dispose();
  }

  void _filterPecas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPecas = car.Carrinho.instance.itens;
      } else {
        _filteredPecas =
            car.Carrinho.instance.itens.where((peca) {
              return (peca.nome ?? '').toLowerCase().contains(query) ||
                  (peca.descricao ?? '').toLowerCase().contains(query) ||
                  (peca.modelo ?? '').toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "Carrinho"),
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
                  hintText: 'Buscar item no carrinho',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 20.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child:
                _filteredPecas.isEmpty
                    ? const Center(
                      child: Text(
                        'Seu carrinho está vazio.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: _filteredPecas.length,
                      itemBuilder: (context, index) {
                        final peca = _filteredPecas[index];
                        return Card(
                          margin: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => PerfilPeca(idPeca: peca.id!),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (peca.imagemFile != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        right: 16.0,
                                      ),
                                      child: SizedBox(
                                        width: 100,
                                        height: 120,
                                        child: Image.network(
                                          'https://192.168.94.220:7101/imagens/${peca.imagemFile}',
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
                                          peca.nome ?? 'Nome Indisponível',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          'Descrição: ${peca.descricao ?? 'Indisponível'}',
                                        ),
                                        Text(
                                          'Preço: ${(peca.valor ?? 0.0).toStringAsFixed(2)}',
                                        ),
                                        Text(
                                          'Fabricante: ${peca.modelo ?? 'Não Informado'}',
                                        ),
                                        Text(
                                          'Garantia: ${peca.garantia ?? 'Não Informada'}',
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        car.Carrinho.instance.removerPeca(peca);
                                        _filterPecas();
                                      });
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${peca.nome} removido do carrinho.',
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total do Carrinho:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'R\$ ${car.Carrinho.instance.valorTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(),
    );
  }
}
