import 'package:exemplo_firebase/data/repositories/auth_repository_impl.dart';
import 'package:exemplo_firebase/domain/usecases/login/logout_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/usuario/obter_usuario_usecase.dart';
import 'package:exemplo_firebase/ui/core/temas/tema_view_model.dart';
import 'package:exemplo_firebase/ui/home/home.dart';
import 'package:exemplo_firebase/ui/home/view_model/home_view_model.dart';
import 'package:flutter/material.dart';

class HomeFactory {
  static Widget create(TemaViewModel temaViewModel) {
    final authRepository = AuthRepositoryImpl();
    final obterUsuarioUsecase = ObterUsuarioUsecase(authRepository);
    final logoutUseCase = LogoutUsecase(authRepository);

    final homeViewModel = HomeViewModel(
      obterUsuarioUsecase: obterUsuarioUsecase,
      logoutUsecase: logoutUseCase,
    );
    return HomePage(homeViewModel: homeViewModel, temaViewModel: temaViewModel);
  }
}
