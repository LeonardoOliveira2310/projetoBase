import 'package:shared_preferences/shared_preferences.dart';
import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';
import 'package:exemplo_firebase/domain/repositories/tema_repository.dart';

class TemaRepositoryImpl implements TemaRepository {
  static const String _chaveTema = 'tema_modo';

  @override
  Future<TemaModoEnum> obterModoTema() async {
    final prefs = await SharedPreferences.getInstance();
    final valorSalvo = prefs.getString(_chaveTema);

    switch (valorSalvo) {
      case 'claro':
        return TemaModoEnum.claro;
      case 'escuro':
        return TemaModoEnum.escuro;
      case 'sistema':
      default:
        return TemaModoEnum.sistema;
    }
  }

  @override
  Future<void> salvarModoTema(TemaModoEnum modo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_chaveTema, modo.name);
  }
}
