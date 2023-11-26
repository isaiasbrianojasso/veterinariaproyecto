import 'package:flutter/material.dart';
import 'modelos/categoria.dart';
import 'modelos/tienda.dart';
import 'modelos/acerca.dart';
import 'modelos/usuario.dart';

import 'citas.dart';

class ScreenMenu extends StatefulWidget {
  @override
  State<ScreenMenu> createState() => ScreenMenuState();
}

class ScreenMenuState extends State<ScreenMenu> {
  @override
  late Color myColor;
  late Size mediaSize;
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Color.fromARGB(255, 42, 104, 44),
      ),
      backgroundColor: Colors.green,
      body: Container(
        child: GridView.builder(
          itemCount: Menu.length,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 104, 44),
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/" + Menu[index].foto,
                      width: 150,
                    ),
                    Text(Menu[index].nombre),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 42, 104, 44),
              ),
              child: Text(
                'Menu Veterinaria',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Home'),

              // Acción al seleccionar la opción 1
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => ScreenMenu()));
              },
            ),
            ListTile(
              title: Text('Citas'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Tienda'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => tienda()));
              },
              //Navigator.pop(context); // Cierra el sidebar
            ),
            ListTile(
              title: Text('Sucursales'),
              onTap: () {
                Navigator.pop(context); // Cierra el sidebar
              },
            ),
            ListTile(
              title: Text('Nosotros'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => acerca()));
              },
            ),
            ListTile(
              title: Text('-------------Admin Area------------------'),
            ),
            ListTile(
              title: Text('Usuarios'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => usuario()));
              },
            ),
            ListTile(
              title: Text('Citas'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => usuario()));
              },
            ),
            ListTile(
              title: Text('Productos'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => usuario()));
              },
            ),
            // Agrega más opciones según tus necesidades
          ],
        ),
      ),
    );
  }
}
