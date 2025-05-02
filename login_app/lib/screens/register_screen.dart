import 'package:flutter/material.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo oscuro consistente
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Colors.grey[900],
      ),
      body: SafeArea(
        child: RegisterForm(),
      ),
    );
  }
}