class UsuarioEntity {
  final String uid;
  final String nome;
  final String cpf;
  final String login;
  final String obs;
  final bool inativo;
  final String ddd;
  final String telefone;
  final String email;
  final String? fotoUrl;
  final bool vendedor;
  final String endereco;
  final String numero;
  final String bairro;
  final String cidade;
  final String cep;
  final String estado;

  UsuarioEntity({
    required this.uid,
    required this.nome,
    required this.email,
    this.cpf = '',
    this.login = '',
    this.obs = '',
    this.inativo = false,
    this.ddd = '',
    this.telefone = '',
    this.fotoUrl,
    this.vendedor = false,
    this.endereco = '',
    this.numero = '',
    this.bairro = '',
    this.cidade = '',
    this.cep = '',
    this.estado = '',
  });
}
