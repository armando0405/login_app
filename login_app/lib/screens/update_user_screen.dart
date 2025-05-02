import 'package:flutter/material.dart';
import '../widgets/update_user_form.dart';

class UpdateUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fondo oscuro consistente
      appBar: AppBar(
        title: Text('Actualizar Usuario'),
        backgroundColor: Colors.grey[900],
      ),
      body: SafeArea(
        child: UpdateUserForm(),
      ),
    );
  }
}