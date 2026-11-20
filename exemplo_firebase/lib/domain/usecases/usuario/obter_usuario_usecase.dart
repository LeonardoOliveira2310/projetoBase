import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/repositories/auth_repository.dart';

class ObterUsuarioUsecase {
  final AuthRepository _repository;

  ObterUsuarioUsecase(this._repository);
  UsuarioEntity? call() => _repository.obterUsuarioAtual();
}
