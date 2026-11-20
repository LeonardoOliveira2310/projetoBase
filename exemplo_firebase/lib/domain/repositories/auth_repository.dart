import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';

abstract class AuthRepository {
  Future<bool> loginComEmailESenha(String email, String senha);
  Future<void> enviarEmailDeVerificacao();
  Future<void> loginComGoogle();

  UsuarioEntity? obterUsuarioAtual();
  Future<void> deslogar();

  Future<String> registrarComEmailESenha(
    String email,
    String senha,
    String nome,
  );
  Future<void> enviarEmailRecuperacaoSenha(String email);
}
