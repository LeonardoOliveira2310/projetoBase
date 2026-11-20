import 'package:exemplo_firebase/domain/entities/usuario_entity.dart';
import 'package:exemplo_firebase/domain/usecases/login/logout_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/usuario/obter_usuario_usecase.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel extends ChangeNotifier {
  final ObterUsuarioUsecase _obterUsuarioUsecase;
  final LogoutUsecase _logoutUsecase;

  HomeViewModel({
    required ObterUsuarioUsecase obterUsuarioUsecase,
    required LogoutUsecase logoutUsecase,
  }) : _obterUsuarioUsecase = obterUsuarioUsecase,
       _logoutUsecase = logoutUsecase;

  UsuarioEntity? get usuario => _obterUsuarioUsecase();

  Future<void> sair() async {
    await _logoutUsecase();
  }
}
