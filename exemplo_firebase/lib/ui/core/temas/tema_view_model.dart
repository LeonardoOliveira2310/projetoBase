import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';
import 'package:exemplo_firebase/domain/usecases/tema/obter_tema_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/tema/salvar_tema_usecase.dart';
import 'package:flutter/material.dart';

class TemaViewModel extends ChangeNotifier {
  final ObterTemaUsecase _obterTemaUsecase;
  final SalvarTemaUsecase _salvarTemaUsecase;

  TemaViewModel({
    required ObterTemaUsecase obterTemaUsecase,
    required SalvarTemaUsecase salvarTemaUsecase,
  }) : _obterTemaUsecase = obterTemaUsecase,
       _salvarTemaUsecase = salvarTemaUsecase;

  TemaModoEnum _modoAtual = TemaModoEnum.sistema;
  TemaModoEnum get modoAtual => _modoAtual;

  ThemeMode get themeMode {
    switch (_modoAtual) {
      case TemaModoEnum.claro:
        return ThemeMode.light;
      case TemaModoEnum.escuro:
        return ThemeMode.dark;
      case TemaModoEnum.sistema:
        return ThemeMode.system;
    }
  }

  Future<void> carregarTemaSalvo() async {
    _modoAtual = await _obterTemaUsecase();
    notifyListeners();
  }

  Future<void> alterarTema(TemaModoEnum novoModo) async {
    if (_modoAtual == novoModo) return;
    _modoAtual = novoModo;
    notifyListeners();
    await _salvarTemaUsecase(novoModo);
  }
}
