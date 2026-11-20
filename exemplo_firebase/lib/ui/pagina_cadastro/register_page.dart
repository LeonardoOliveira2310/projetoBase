import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailEC = TextEditingController();
  final senhaEC = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    emailEC.dispose();
    senhaEC.dispose();
    super.dispose();
  }

  void registrarUsuario() async {
    if (emailEC.text.isEmpty) {
      FirebaseCrashlytics.instance.setCustomKey("EMAIL_VAZIO", "e-mail vazio");
    }
    if (senhaEC.text.isEmpty) {
      FirebaseCrashlytics.instance.setCustomKey("SENHA_VAZIA", "senha vazio");
    }
    try {
      final credenciais = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailEC.text,
            password: senhaEC.text,
          );
      credenciais.user?.sendEmailVerification();
    } catch (e, stack) {
      FirebaseCrashlytics.instance.setCustomKey(
        "ERRO_CADASTRAR",
        "Verificar email e senha: $e",
      );
      FirebaseCrashlytics.instance.recordError(
        e,
        stack,
        reason: "Erro ao registrar usuário",
        fatal: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Usuário')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: emailEC,
                decoration: InputDecoration(label: Text('e-mail')),
              ),
              TextField(
                controller: senhaEC,
                decoration: InputDecoration(label: Text('senha')),
              ),
              ElevatedButton(
                onPressed: registrarUsuario,
                child: Text('Cadastrar Usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
