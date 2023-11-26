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

  Future<void> _addUser(String nombre, String correo) async {
    final newUser = {
      'nombre': nombre,
      'correo': correo,
    };

    await _database.insert('Usuario', newUser);
    _loadUsers();
  }

  Future<void> _editUser(int userId) async {
    // Obtener el usuario actual
    Map<String, dynamic> userToEdit = _users.firstWhere(
          (user) => user['id'] == userId,
    );

    String nombre = userToEdit['nombre'] ?? '';
    String correo = userToEdit['correo'] ?? '';

    // Mostrar el modal para editar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditUserDialog(nombre, correo, userId);
      },
    );
  }

  Future<void> _updateUser(int userId, String nombre, String correo) async {
    await _database.update(
      'Usuario',
      {'nombre': nombre, 'correo': correo},
      where: 'id = ?',
      whereArgs: [userId],
    );

    _loadUsers();
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
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _buildAddUserDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddUserDialog() {
    String nombre = '';
    String correo = '';

    return AlertDialog(
      title: Text('Agregar Usuario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              nombre = value;
            },
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              correo = value;
            },
            decoration: InputDecoration(labelText: 'Correo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _addUser(nombre, correo);
            Navigator.pop(context);
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }

  Widget _buildEditUserDialog(String nombre, String correo, int userId) {
    String editedNombre = nombre;
    String editedCorreo = correo;

    return AlertDialog(
      title: Text('Editar Usuario'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            onChanged: (value) {
              editedNombre = value;
            },
            controller: TextEditingController(text: nombre),
            decoration: InputDecoration(labelText: 'Nombre'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedCorreo = value;
            },
            controller: TextEditingController(text: correo),
            decoration: InputDecoration(labelText: 'Correo'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            _updateUser(userId, editedNombre, editedCorreo);
            Navigator.pop(context);
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
