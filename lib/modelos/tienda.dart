import 'package:flutter/material.dart';
import 'modelos/categoria.dart';

class tienda extends StatefulWidget {
  @override
  State<tienda> createState() => tiendaState();
}

class tiendaState extends State<tienda> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tienda"),
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
                onTap: () {
                  // Acción al seleccionar un producto
                  // Puedes agregar la navegación o acción que desees aquí
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/" + Menu[index].foto,
                      width: 150,
                    ),
                    Text(Menu[index].nombre),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                
                        ElevatedButton(
                          onPressed: () {
                            // Acción al hacer clic en el botón de agregar al carrito
                            // Puedes agregar la lógica para agregar al carrito aquí
                          },
                          child: Text('Agregar al carrito'),
                        ),
                      ],
                    ),
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
              title: Text('Citas'),
              onTap: () {
                // Acción al seleccionar la opción 1
                Navigator.pop(context); // Cierra el sidebar
              },
            ),
            ListTile(
              title: Text('Tienda'),
              onTap: () {
                Navigator.pop(context); // Cierra el sidebar
              },
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
