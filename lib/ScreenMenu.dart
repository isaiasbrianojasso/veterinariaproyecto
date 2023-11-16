import 'package:flutter/material.dart';
import 'modelos/categoria.dart';

class ScreenMenu extends StatefulWidget {
  @override
  State<ScreenMenu> createState() => ScreenMenuState();
}

class ScreenMenuState extends State<ScreenMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MENU"),
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
                'Sidebar Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Opción 1'),
              onTap: () {
                // Acción al seleccionar la opción 1
                Navigator.pop(context); // Cierra el sidebar
              },
            ),
            ListTile(
              title: Text('Opción 2'),
              onTap: () {
                // Acción al seleccionar la opción 2
                Navigator.pop(context); // Cierra el sidebar
              },
            ),
            // Agrega más opciones según tus necesidades
          ],
        ),
      ),
    );
  }
}
