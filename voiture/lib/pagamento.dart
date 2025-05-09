import 'dart:convert';
import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:voiture/Controlador/ReqResp.dart';
import 'package:voiture/Modelos/usedSettings.dart' as uS;
import 'package:voiture/menuPrincipal.dart';
import 'package:voiture/perfilUser.dart';
import 'package:http/http.dart' as http;

class Pagamento extends StatefulWidget {
  final int idPeca;
  final int numeroPecas;

  const Pagamento({
    Key? key,
    required this.idPeca,
    required this.numeroPecas,
  }) : super(key: key);

  @override
  _PagamentoState createState() => _PagamentoState();
}

class _PagamentoState extends State<Pagamento> {
  bool _cartaoCreditoSelecionado = false;
  bool _cartaoDebitoSelecionado = false;
  double _precoUnitario = 250.00;
  int _quantidadePecas = 1;
  double _totalCompra = 250.00;

  final TextEditingController numCartao = TextEditingController();
  final TextEditingController validadeController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  final maskCartaoFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: { '#': RegExp(r'\d') },
  );

  final maskValidadeFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: { '#': RegExp(r'\d') },
  );

  @override
  void initState() {
    super.initState();
    _quantidadePecas = widget.numeroPecas;
    _atualizarTotalCompra();
  }

  void _atualizarTotalCompra() async {
    ReqResp r = ReqResp(
      "https://192.168.18.61:7101",
      httpClient: createIgnoringCertificateClient(),
    );
    http.Response resp = await r.getById("peca/", widget.idPeca);
    setState(() {
      Map<String, dynamic> data = jsonDecode(resp.body);
      _precoUnitario = data['preco'];
      _totalCompra = _precoUnitario * _quantidadePecas;
    });
  }

   bool validarCompra() {
    final ccValidator = CreditCardValidator();
    final cardNumberWithoutSpaces = numCartao.text.replaceAll(' ', '');

    print('Número do Cartão (com espaços): ${numCartao.text}');
    print('Número do Cartão (sem espaços): $cardNumberWithoutSpaces');

    final results = ccValidator.validateCCNum(cardNumberWithoutSpaces);

    print('Resultado da Validação: ${results.isValid}');
    if (results.isValid) {
      print('Bandeira Detectada: ${results.ccType}');
      return true;
    } else {
      print('Número Inválido - Erro: ${results.message}'); // Imprime os erros de validação
      return false;
    }
  }


  void _selecionarCartaoCredito(bool? value) {
    setState(() {
      _cartaoCreditoSelecionado = value ?? false;
      if (_cartaoCreditoSelecionado) _cartaoDebitoSelecionado = false;
    });
  }

  void _selecionarCartaoDebito(bool? value) {
    setState(() {
      _cartaoDebitoSelecionado = value ?? false;
      if (_cartaoDebitoSelecionado) _cartaoCreditoSelecionado = false;
    });
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MenuPrincipal()),
        );
      } else if (index == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PerfilUser()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: uS.UsedAppBar(nome: "pagamento"),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Pagamento',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Resumo da compra:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[400],
              ),
            ),
            Text(
              '${widget.numeroPecas}x R\$ ${_precoUnitario.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0, color: Colors.black),
            ),
            const SizedBox(height: 24.0),
            const Text(
              'Opções de pagamento',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _cartaoCreditoSelecionado,
                  onChanged: _selecionarCartaoCredito,
                  activeColor: Colors.blue,
                ),
                const Text('Cartão de Crédito', style: TextStyle(color: Colors.black)),
              ],
            ),
            Row(
              children: <Widget>[
                Checkbox(
                  value: _cartaoDebitoSelecionado,
                  onChanged: _selecionarCartaoDebito,
                  activeColor: Colors.blue,
                ),
                const Text('Cartão de Débito', style: TextStyle(color: Colors.black)),
              ],
            ),
            if (_cartaoCreditoSelecionado || _cartaoDebitoSelecionado)
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: numCartao,
                            inputFormatters: [maskCartaoFormatter],
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Número do cartão',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]!),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          width: 100.0,
                          child: TextField(
                            controller: validadeController,
                            inputFormatters: [maskValidadeFormatter],
                            maxLength: 5,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Validade',
                              hintText: 'MM/AA',
                              counterText: '',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]!),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            keyboardType: TextInputType.datetime,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: nomeController,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'Nome no cartão',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]!),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        SizedBox(
                          width: 80.0,
                          child: TextField(
                            controller: cvvController,
                            maxLength: 3,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              labelText: 'CVV',
                              counterText: '',
                              labelStyle: TextStyle(color: Colors.grey[400]),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey[400]!),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 32.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  if (!_cartaoCreditoSelecionado && !_cartaoDebitoSelecionado) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecione uma forma de pagamento')),
                    );
                    return;
                  }
                  final metodo = _cartaoCreditoSelecionado ? 'Crédito' : 'Débito';
                  if (validarCompra()) {
                    // TODO: integrar processamento de pagamento
                    print('Pagamento com Cartão de $metodo aprovado');
                  } else {
                    print(numCartao.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      
                      const SnackBar(content: Text('Número de cartão inválido')),
                    );
                  }
                },
                child: const Text(
                  'Confirmar pagamento',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: uS.UsedBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
