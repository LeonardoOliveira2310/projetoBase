import 'package:exemplo_firebase/domain/entities/tema_modo_enum.dart';

abstract class TemaRepository {
  Future<TemaModoEnum> obterModoTema();
  Future<void> salvarModoTema(TemaModoEnum modo);
}
