class Usuario {
  static Usuario? _instance;

  String _cpf;
  String _nome;
  String _email;
  String _password;
  String _numeroResid;
  int _idEnd;
  int _id;

  Usuario._(this._cpf, this._nome, this._email, this._password, this._numeroResid, this._idEnd, this._id);

  static Usuario get instance {
    _instance ??= Usuario._(
      "",
      "",
      "",
      "",
      "",
      0,
      0,
    );
    return _instance!;
  }

  String get cpf => _cpf;
  String get nome => _nome;
  String get email => _email;
  String get password => _password;
  String get numeroResid => _numeroResid;
  int get idEnd => _idEnd;
  int get id => _id;

  set cpf(String novoCpf) {
    _cpf = novoCpf;
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

  set idEnd(int novoIdEnd) {
    _idEnd = novoIdEnd;
  }

  set id(int novoId) {
    _id = novoId;
  }

  void setDados(String cpf, String nome, String email, String password, String numeroResid, int idEnd, int id) {
    _cpf = cpf;
    _nome = nome;
    _email = email;
    _password = password;
    _numeroResid = numeroResid;
    _idEnd = idEnd;
    _id = id;
  }
}