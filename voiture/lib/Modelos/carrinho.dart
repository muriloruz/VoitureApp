import 'package:voiture/Modelos/peca.dart';
/*
  - Classe carrinho, singletom, usada para salvar as peças em uma lista.
*/
class Carrinho {
  static Carrinho? _instance;
  final List<Peca> _itens = [];
  final erro = false;
  Carrinho._();

  static Carrinho get instance {
    _instance ??= Carrinho._();
    return _instance!;
  }

  void adicionarPeca(Peca novaPeca) {
    final index = _itens.indexWhere((item) => item.id == novaPeca.id);
    if (index != -1) {
      print('Peça com ID ${novaPeca.id} já existe no carrinho.');
      erro == true;
    } else {
      _itens.add(novaPeca);
    }
  }

  void removerPeca(Peca peca) {
    _itens.remove(peca);
  }

  void removerPecaPorIndice(int index) {
    if (index >= 0 && index < _itens.length) {
      _itens.removeAt(index);
    }
  }

  void limparCarrinho() {
    _itens.clear();
  }

  List<Peca> get itens => _itens;

  int get quantidadeItens => _itens.length;

  double get valorTotal {
    double total = 0.0;
    for (final peca in _itens) {
      total += peca.valor ?? 0.0;
    }
    return total;
  }

  
}