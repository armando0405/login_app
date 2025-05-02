import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<dynamic> _users = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await ApiService.getUsers();

      if (response['statusCode'] == 200) {
        setState(() {
          _users = response['users'] ?? [];
        });
      } else {
        setState(() {
          _errorMessage = response['detail'] ?? 'Error al obtener usuarios';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error de conexión: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          backgroundColor: Colors.grey[900],
          elevation: 5,
          leading: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10.0, bottom: 10.0),
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: Colors.tealAccent[100], size: 20),
              label: Text("Login", style: TextStyle(color: Colors.tealAccent[100])),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.tealAccent[100]!),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                foregroundColor: Colors.tealAccent[100],
              ),
            ),
          ),
          title: Text(
            'Lista de Usuarios',
            style: TextStyle(
              color: Colors.tealAccent[100],
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.tealAccent[100]),
              onPressed: _fetchUsers,
              tooltip: 'Actualizar',
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: Colors.tealAccent[100]));
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, style: TextStyle(color: Colors.red[300], fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchUsers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.tealAccent[700],
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Reintentar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    if (_users.isEmpty) {
      return Center(
        child: Text(
          'No hay usuarios registrados',
          style: TextStyle(color: Colors.tealAccent[100], fontSize: 18, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.grey[900],
            elevation: 6,
            borderRadius: BorderRadius.circular(16),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.tealAccent[700],
                child: Icon(Icons.person, color: Colors.black, size: 32),
              ),
              title: Text(
                user['email'] ?? 'Sin email',
                style: TextStyle(
                  color: Colors.tealAccent[100],
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              subtitle: Text(
                'ID: ${user['id'] ?? 'N/A'}',
                style: TextStyle(
                  color: Colors.tealAccent[100]?.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.tealAccent[100], size: 20),
            ),
          ),
        );
      },
    );
  }
}