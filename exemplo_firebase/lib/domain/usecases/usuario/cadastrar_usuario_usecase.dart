import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';
import 'package:exemplo_firebase/domain/repositories/usuario_repository.dart';

class CadastrarUsuarioUsecase {
  final AuthRepository _authRepository;
  final UsuarioRepository _usuarioRepository;

  CadastrarUsuarioUsecase({
    required AuthRepository authRepository,
    required UsuarioRepository usuarioRepository,
  }) : _authRepository = authRepository,
       _usuarioRepository = usuarioRepository;

  Future<void> call({
    required UsuarioEntity dadosUsuario,
    required String senha,
  }) async {
    final uidGerado = await _authRepository.registrarComEmailESenha(
      dadosUsuario.email,
      senha,
      dadosUsuario.nome,
    );

    final usuarioCompleto = UsuarioEntity(
      uid: uidGerado,
      nome: dadosUsuario.nome,
      email: dadosUsuario.email,
      cpf: dadosUsuario.cpf,
      login: dadosUsuario.login.isEmpty
          ? dadosUsuario.email
          : dadosUsuario.login,
      obs: dadosUsuario.obs,
      inativo: dadosUsuario.inativo,
      ddd: dadosUsuario.ddd,
      telefone: dadosUsuario.telefone,
      fotoUrl: dadosUsuario.fotoUrl,
      vendedor: dadosUsuario.vendedor,
      endereco: dadosUsuario.endereco,
      numero: dadosUsuario.numero,
      bairro: dadosUsuario.bairro,
      cidade: dadosUsuario.cidade,
      cep: dadosUsuario.cep,
      estado: dadosUsuario.estado,
    );

    await _usuarioRepository.salvarUsuario(usuarioCompleto);

    await _authRepository.enviarEmailDeVerificacao();
  }
}
