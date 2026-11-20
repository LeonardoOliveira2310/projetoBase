import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';

abstract class UsuarioRepository {
  Future<void> salvarUsuario(UsuarioEntity usuario);
  Future<UsuarioEntity?> buscarUsuarioPorUid(String uid);
}
