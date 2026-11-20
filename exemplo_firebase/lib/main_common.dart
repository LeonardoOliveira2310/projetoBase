import 'dart:ui';
import 'package:exemplo_firebase/data/repositories/tema_repository_impl.dart';
import 'package:exemplo_firebase/data/services/crashlytics_auth_observer.dart';
import 'package:exemplo_firebase/di/factories/home_factory.dart';
import 'package:exemplo_firebase/di/factories/login_factory.dart';
import 'package:exemplo_firebase/di/factories/registro_usuario_factory.dart';
import 'package:exemplo_firebase/domain/usecases/tema/obter_tema_usecase.dart';
import 'package:exemplo_firebase/domain/usecases/tema/salvar_tema_usecase.dart';
import 'package:exemplo_firebase/ui/core/temas/tema_config.dart';
import 'package:exemplo_firebase/ui/core/temas/tema_view_model.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'firebase_options.dart';

Future<void> iniciarApp({
  required String arquivoEnv,
  required AppTemaConfig temaConfig,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: arquivoEnv);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  final temaRepository = TemaRepositoryImpl();
  final temaViewModel = TemaViewModel(
    obterTemaUsecase: ObterTemaUsecase(temaRepository),
    salvarTemaUsecase: SalvarTemaUsecase(temaRepository),
  );

  await temaViewModel.carregarTemaSalvo();

  //inicia o monitoramento do usuário para o Crashlytics antes de rodar o app
  CrashlyticsAuthObserver.iniciar();

  runApp(MyApp(temaViewModel: temaViewModel, temaConfig: temaConfig));
}

class MyApp extends StatelessWidget {
  final AppTemaConfig temaConfig;
  final TemaViewModel temaViewModel;
  const MyApp({
    super.key,
    required this.temaConfig,
    required this.temaViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: temaViewModel,
      builder: (context, _) {
        return MaterialApp(
          title: 'Exemplo Firebase',
          themeMode: temaViewModel.themeMode,
          theme: temaConfig.lightTheme,
          darkTheme: temaConfig.darkTheme,
          initialRoute: '/login',
          routes: {
            '/login': (_) => LoginFactory.create(),
            '/home/homePage': (_) => HomeFactory.create(temaViewModel),
            '/registro_usuario': (_) => RegistroUsuarioFactory.create(),
          },
        );
      },
    );
  }
}
