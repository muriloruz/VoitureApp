class Usuario {
  /*
   -Classe modelo para salvar alguns dados do ususarios, como o token e o id;
  - Essa classe é importante principalmente no caso do vendedor, pois só é enviado para API na segunda tela;
  - Classe SingleTom para ter uma unica insância.
  */ 
  static Usuario? _instance;

  String _token;
  String _cpf;
  String _nome;
  String _email;
  String _password;
  String _numeroResid;
  String _role;
  final String _dados;
  String _id;

  Usuario._(this._cpf, this._nome, this._email, this._password, this._numeroResid, this._id, this._token,this._role,this._dados);

  static Usuario get instance {
    _instance ??= Usuario._(
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      "",
      ""
    );
    return _instance!;
  }

  String get cpf => _cpf;
  String get nome => _nome;
  String get email => _email;
  String get password => _password;
  String get numeroResid => _numeroResid;
  String get token => _token;
  String get id => _id;
  String get role => _role;
  String get dados => _dados;

  set cpf(String novoCpf) {
    _cpf = novoCpf;
  }

  set dados(String novoDado) {
    _cpf = novoDado;
  }
  set nome(String novoNome) {
    _nome = novoNome;
  }

  set email(String novoEmail) {
    _email = novoEmail;
  }

  set password(String novoPassword) {
    _password = novoPassword;
  }

  set numeroResid(String novoNumeroResid) {
    _numeroResid = novoNumeroResid;
  }

  set role(String novaRole){
    _role = novaRole;
  }

  set id(String novoId) {
    _id = novoId;
  }

  set token(String novoToken){
    _token = novoToken;
  }

  
  void setDados(String cpf, String nome, String email, String password, String numeroResid,  String id, String token, String role) {
    _cpf = cpf;
    _nome = nome;
    _email = email;
    _password = password;
    _numeroResid = numeroResid;
    _id = id;
    _token = token;
    _role = role;
  }
}