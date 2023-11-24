import 'package:flutter/material.dart';
import '/ScreenMenu.dart';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class Usuario {
  int id;
  String nombre;
  String correo;
  String password;

  Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.password,
  });
}

Future<void> _createDatabase(Database db, int version) async {
  // Crear tabla Usuario
  await db.execute('''
    CREATE TABLE Usuario (
      id INTEGER PRIMARY KEY,
      nombre TEXT,
      correo TEXT,
      password TEXT
    )
  ''');

  // Insertar un usuario de ejemplo
  await db.rawInsert('''
    INSERT INTO Usuario (nombre, correo, password)
    VALUES (?, ?, ?)
  ''', ["Jose Isaias", "isaias.briano@gmail.com", "password123"]);
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  late Size mediaSize;
  late Color myColor;
  TextEditingController passwordController = TextEditingController();
  bool rememberUser = false;

  Widget _buildTop() {
    return SizedBox(
      width: mediaSize.width,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.pets,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "Clinica Vet",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 40,
                letterSpacing: 2),
          )
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
        )),
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
              color: myColor, fontSize: 32, fontWeight: FontWeight.w500),
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
        _buildRememberForgot(),
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
      style: const TextStyle(color: Colors.grey),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {isPassword = false}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword ? Icon(Icons.remove_red_eye) : Icon(Icons.done),
      ),
      obscureText: isPassword,
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () {},
          child: _buildGreyText("He olvidado mi contraseña"),
        )
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () async {
        debugPrint("Email: ${emailController.text}");
        debugPrint("Password: ${passwordController.text}");

        if (passwordController.text.isEmpty || emailController.text.isEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Aviso"),
                content:
                    Text("El correo y la contraseña no pueden estar vacíos"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Realizar la consulta a la base de datos o comparación directa
          bool loginSuccessful = await _authenticateUser(
            emailController.text,
            passwordController.text,
          );

          if (loginSuccessful) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ScreenMenu()),
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Aviso"),
                  content: Text("Correo o contraseña incorrectos"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
    return false;
  }

  Widget _buildOtherLogin() {
    return Center(
      child: Column(
        children: [
          _buildGreyText("¿Eres nuevo? Regístrate aquí"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Tab(
                icon: Image.asset("assets/images/log.png"),
              )
            ],
          )
        ],
      ),
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
                  myColor.withOpacity(0.2), BlendMode.dstATop))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(children: [
          Positioned(top: 80, child: _buildTop()),
          Positioned(bottom: 0, child: _buildBottom()),
        ]),
      ),
    );
  }
}
