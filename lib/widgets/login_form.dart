import 'package:flutter/material.dart';
import 'package:crud_session/screens/delete_user_screen.dart';
import 'package:crud_session/screens/register_screen.dart';
import 'package:crud_session/screens/update_user_screen.dart';
import 'package:crud_session/screens/user_list_screen.dart';
import '../services/api_service.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    
    final String email = _emailController.text;
    final String password = _passwordController.text;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.login(email, password);

      if (response['statusCode'] == 200) {
        _showSuccessDialog(context, 'Bienvenido: ${response['user']['email']}');
      } else {
        _showErrorDialog(context, response['detail']);
      }
    } catch (e) {
      _showErrorDialog(context, 'No se pudo conectar al servidor. Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue[850],
        title: Text('Login exitoso', style: TextStyle(color: Colors.white)),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blue[300])),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[850],
        title: Text('Error', style: TextStyle(color: Colors.red[300])),
        content: Text(message, style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.blue[300])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            TextFormField(
              controller: _emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.email, color: Colors.grey[500]),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su email';
                }
                if (!value.contains('@')) {
                  return 'Ingrese un email válido';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              style: TextStyle(color: Colors.white),
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                labelStyle: TextStyle(color: Colors.grey[400]),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[700]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue[800]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.grey[500]),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su contraseña';
                }
                if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: Colors.blue[300]))
                : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
            SizedBox(height: 16),
            Divider(color: Colors.grey[700]),
            SizedBox(height: 8),
            _buildActionButton(
              text: '¿No tienes cuenta? Regístrate',
              icon: Icons.person_add,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              ),
            ),
            _buildActionButton(
              text: 'Actualizar usuario',
              icon: Icons.edit,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateUserScreen()),
              ),
            ),
            _buildActionButton(
              text: 'Eliminar usuario',
              icon: Icons.delete,
              color: Colors.red[300],
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DeleteUserScreen()),
              ),
            ),
            _buildActionButton(
              text: 'Ver todos los usuarios',
              icon: Icons.list,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserListScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: color ?? Colors.blue[300],
          side: BorderSide(color: Colors.grey[700]!),
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(text),
          ],
        ),
      ),
    );
  }
}