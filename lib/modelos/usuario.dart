import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Usuario {
  final int id;
  final String nombre;
  final String correo;
  final String password;

  Usuario({required this.id, required this.nombre, required this.correo, required this.password});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'password': password,
    };
  }
}

class UsuarioDatabase {
  Database? _database;

  Future<string> openDatabase() async {
    if (_database == null) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'usuarios_database.db'),
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE Usuario (
              id INTEGER PRIMARY KEY,
              nombre TEXT,
              correo TEXT,
              password TEXT
            )
          ''');
        },
        version: 1,
      );
    }
  }

  Future<void> insertUsuario(Usuario usuario) async {
    await _database!.insert(
      'Usuario',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Usuario>> getUsuarios() async {
    final List<Map<String, dynamic>> maps = await _database!.query('Usuario');

    return List.generate(maps.length, (i) {
      return Usuario(
        id: maps[i]['id'],
        nombre: maps[i]['nombre'],
        correo: maps[i]['correo'],
        password: maps[i]['password'],
      );
    });
  }
}

class UsuarioListScreen extends StatefulWidget {
  const UsuarioListScreen({Key? key}) : super(key: key);

  @override
  _UsuarioListScreenState createState() => _UsuarioListScreenState();
}

class _UsuarioListScreenState extends State<UsuarioListScreen> {
  UsuarioDatabase _usuarioDatabase = UsuarioDatabase();

  @override
  void initState() {
    super.initState();
    _abrirBaseDatos();
  }

  Future<void> _abrirBaseDatos() async {
    try {
      await _usuarioDatabase.openDatabase();
      setState(() {});
    } catch (e) {
      print("Error al abrir la base de datos: $e");
      // Manejar el error de apertura de la base de datos
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarioDatabase.getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final usuarios = snapshot.data!;
            return ListView.builder(
              itemCount: usuarios.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('ID: ${usuarios[index].id}'),
                  subtitle: Text('Nombre: ${usuarios[index].nombre}\nCorreo: ${usuarios[index].correo}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
