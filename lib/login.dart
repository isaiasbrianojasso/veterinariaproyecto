import 'package:flutter/material.dart';
import '/ScreenMenu.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Size mediaSize;
  late Color myColor;
  bool rememberUser = false;

  late Database _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      path.join(await getDatabasesPath(), 'clinicavet.db'),
      version: 1,
      onCreate: _createDatabase,
    );
    // Create the Producto table
    await _createProducto(_database, 1);
    // Uncomment the line below if you want to delete the database and recreate it on every app start
    // await deleteDatabase(path.join(await getDatabasesPath(), 'clinicavet.db'));

    // await deleteDatabase(path.join(await getDatabasesPath(), 'clinicavet.db'));
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Usuario (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        correo TEXT,
        password TEXT
      )
    ''');

    await db.rawInsert('''
      INSERT INTO Usuario (nombre, correo, password)
      VALUES (?, ?, ?)
    ''', ["Ejemplo Usuario", "ejemplo@email.com", "password123"]);
  }

  Future<void> _createProducto(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS Producto (
        id INTEGER PRIMARY KEY,
        nombre TEXT,
        descripcion TEXT,
        cantidad INT,
        precio INT
      )
    ''');

    await db.rawInsert('''
      INSERT INTO Producto (nombre, descripcion, cantidad,precio)
      VALUES (?, ?, ?, ?)
    ''', ["Croquetas Doggy", "Las mejores", 40, 5]);
  }

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/images/log.png",
            width: 100,
            height: 100,
          ),
          Text(
            "Nina's Vet",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 40,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return SizedBox(
      width: mediaSize.width,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "¡Bienvenido!",
          style: TextStyle(
            color: myColor,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        _buildGreyText("Por favor inicia sesión"),
        const SizedBox(
          height: 60,
        ),
        _buildGreyText("Dirección de correo electrónico"),
        _buildInputField(emailController),
        const SizedBox(height: 40),
        _buildGreyText("Contraseña"),
        _buildInputField(passwordController, isPassword: true),
        const SizedBox(height: 20),
        //_buildRememberForgot(),
        const SizedBox(height: 20),
        _buildLoginButton(),
        const SizedBox(height: 20),
        _buildOtherLogin(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  /*Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: _buildGreyText("He olvidado mi contraseña"),
        ),
      ],
    );
  }*/

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("Email: ${emailController.text}");
        debugPrint("Password: ${passwordController.text}");
        if (passwordController.text.isEmpty || emailController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text("Aviso"),
                content: Text("No puede estar vacío el correo o la contraseña"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          bool isAuthenticated = await _authenticateUser(
            emailController.text,
            passwordController.text,
          );

          if (isAuthenticated) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScreenMenu()),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("Usuario o contraseña incorrectos"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: Text("OK"),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 20,
        shadowColor: myColor,
        minimumSize: const Size.fromHeight(60),
      ),
      child: const Text("Login"),
    );
  }

  Future<bool> _authenticateUser(String email, String password) async {
    List<Map<String, dynamic>> result = await _database.query(
      'Usuario',
      where: 'correo = ? AND password = ?',
      whereArgs: [email, password],
    );

    return result.isNotEmpty;
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("¿Eres nuevo? Regístrate aquí"),
          InkWell(
            onTap: () {
              _showRegisterDialog(context);
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Icon(
                Icons.pets,
                size: 50,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro de Usuario'),
          content: _buildRegisterForm(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // lógica de registro
                Navigator.of(context).pop();
              },
              child: Text('Registrar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: 'Nombre'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese un nombre';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Correo'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese un correo';
            }
            return null;
          },
        ),
        TextFormField(
          decoration: InputDecoration(labelText: 'Contraseña'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, ingrese una contraseña';
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        color: myColor,
        image: DecorationImage(
          image: const AssetImage("assets/images/Background.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            myColor.withOpacity(0.2),
            BlendMode.dstATop,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 80, child: _buildTop()),
            Positioned(bottom: 0, child: _buildBottom()),
          ],
        ),
      ),
    );
  }
}
