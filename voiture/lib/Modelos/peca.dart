import 'dart:io';

class Peca {
  /*
    - Classe modelo para salvar os dados de uma peça.
    - Essa classe é utilizada para criar e manipular informações de peças no carrinho.
  */

  String _nome;
  String _descricao;
  String _modelo;
  double _valor;
  String _garantia;
  String _imagemFile;
  String _vendId;
  int? _id; 

  Peca({
    required String nome,
    required String descricao,
    required String modelo,
    required double valor,
    required String garantia,
    required String imagemFile,
    required String vendId,
    int? id,
  })  : _nome = nome,
        _descricao = descricao,
        _modelo = modelo,
        _valor = valor,
        _garantia = garantia,
        _imagemFile = imagemFile,
        _vendId = vendId,
        _id = id;


  String get nome => _nome;
  String get descricao => _descricao;
  String get modelo => _modelo;
  double get valor => _valor;
  String get garantia => _garantia;
  String get imagemFile => _imagemFile;
  String get vendId => _vendId;
  int? get id => _id;


  set nome(String novoNome) {
    _nome = novoNome;
  }

  set descricao(String novaDescricao) {
    _descricao = novaDescricao;
  }

  set modelo(String novoModelo) {
    _modelo = novoModelo;
  }


  set valor(double novoValor) {
    _valor = novoValor;
  }

  set garantia(String novaGarantia) {
    _garantia = novaGarantia;
  }

  set imagemFile(String novaImagemFile) {
    _imagemFile = novaImagemFile;
  }

  set vendId(String novoVendId) {
    _vendId = novoVendId;
  }

  set id(int? novoId) {
    _id = novoId;
  }

  void setDadosPeca({
    required String nome,
    required String descricao,
    required String modelo,
    required double valor,
    required String garantia,
    required String imagemFile,
    required String vendId,
    int? id,
  }) {
    _nome = nome;
    _descricao = descricao;
    _modelo = modelo;
    _valor = valor;
    _garantia = garantia;
    _imagemFile = imagemFile;
    _vendId = vendId;
    _id = id;
  }
}