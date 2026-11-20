import 'package:exemplo_firebase/main_common.dart';
import 'package:exemplo_firebase/ui/core/temas/tema_config.dart';

Future<void> main() async {
  await iniciarApp(arquivoEnv: '.env.dev', temaConfig: AppTemaConfig.dev());
}
