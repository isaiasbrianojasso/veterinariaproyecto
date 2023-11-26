import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class usuario extends StatefulWidget {
  const usuario({Key? key}) : super(key: key);

  @override
  _UsuarioListScreenState createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<usuario> {
  late Database _database;
  late List<Map<String, dynamic>> _users;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'clinicavet.db'),
      version: 1,
    );
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final List<Map<String, dynamic>> users = await _database.query('Usuario');
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    print("Agregar usuario");
    // Implementa la lógica para agregar un nuevo usuario aquí
    // Puedes mostrar un diálogo o navegar a una pantalla de formulario
  }

  Future<void> _editUser(int userId) async {
    // Implementa la lógica para editar el usuario con el ID proporcionado
    // Puedes mostrar un diálogo o navegar a una pantalla de formulario
  }

  Future<void> _deleteUser(int userId) async {
    await _database.delete('Usuario', where: 'id = ?', whereArgs: [userId]);
    _loadUsers();
  }

  @override
  late Color myColor;
  late Size mediaSize;
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        backgroundColor: Color.fromARGB(255, 42, 104, 44),
      ),
      backgroundColor: Colors.green,
      body: Container(
        color: Colors.white, // Establecer el color de fondo a blanco
        child: ListView.builder(
          itemCount: _users.length,
          itemBuilder: (context, index) {
            final user = _users[index];
            return ListTile(
              title: Text(user['nombre']),
              subtitle: Text(user['correo']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editUser(user['id']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteUser(user['id']);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
