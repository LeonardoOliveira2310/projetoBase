import 'package:exemplo_firebase/ui/core/temas/tema_view_model.dart';
import 'package:exemplo_firebase/ui/home/view_model/home_view_model.dart';
import 'package:exemplo_firebase/ui/home/widget/custom_drawner.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final HomeViewModel homeViewModel;
  final TemaViewModel temaViewModel;

  const HomePage({
    super.key,
    required this.homeViewModel,
    required this.temaViewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      drawer: CustomDrawner(
        usuario: homeViewModel.usuario,
        temaViewModel: temaViewModel,
        aoClicarSair: () async {
          await homeViewModel.sair();
          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/login');
          }
        },
      ),
      body: const Center(child: Text('bem-vindo!')),
    );
  }
}
