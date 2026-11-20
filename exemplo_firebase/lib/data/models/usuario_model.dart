import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';

class UsuarioModel extends UsuarioEntity {
  UsuarioModel({
    required super.uid,
    required super.nome,
    required super.email,
    super.cpf,
    super.login,
    super.obs,
    super.inativo,
    super.ddd,
    super.telefone,
    super.fotoUrl,
    super.vendedor,
    super.endereco,
    super.numero,
    super.bairro,
    super.cidade,
    super.cep,
    super.estado,
  });

  /// Converte uma UsuarioEntity pura em UsuarioModel para salvar no banco
  factory UsuarioModel.fromEntity(UsuarioEntity entity) {
    return UsuarioModel(
      uid: entity.uid,
      nome: entity.nome,
      email: entity.email,
      cpf: entity.cpf,
      login: entity.login,
      obs: entity.obs,
      inativo: entity.inativo,
      ddd: entity.ddd,
      telefone: entity.telefone,
      fotoUrl: entity.fotoUrl,
      vendedor: entity.vendedor,
      endereco: entity.endereco,
      numero: entity.numero,
      bairro: entity.bairro,
      cidade: entity.cidade,
      cep: entity.cep,
      estado: entity.estado,
    );
  }

  /// Converte um documento (Map) vindo do Cloud Firestore em UsuarioModel
  factory UsuarioModel.fromMap(Map<String, dynamic> map, String documentId) {
    return UsuarioModel(
      uid: documentId,
      nome: map['nome'] ?? '',
      email: map['email'] ?? '',
      cpf: map['cpf'] ?? '',
      login: map['login'] ?? '',
      obs: map['obs'] ?? '',
      inativo: map['inativo'] ?? false,
      ddd: map['ddd'] ?? '',
      telefone: map['telefone'] ?? '',
      fotoUrl: map['fotoUrl'],
      vendedor: map['vendedor'] ?? false,
      endereco: map['endereco'] ?? '',
      numero: map['numero'] ?? '',
      bairro: map['bairro'] ?? '',
      cidade: map['cidade'] ?? '',
      cep: map['cep'] ?? '',
      estado: map['estado'] ?? '',
    );
  }

  /// Converte o objeto em Map para gravar no Cloud Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nome': nome,
      'email': email,
      'cpf': cpf,
      'login': login,
      'obs': obs,
      'inativo': inativo,
      'ddd': ddd,
      'telefone': telefone,
      'fotoUrl': fotoUrl,
      'vendedor': vendedor,
      'endereco': endereco,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'cep': cep,
      'estado': estado,
    };
  }
}
