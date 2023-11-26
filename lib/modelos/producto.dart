import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class Producto extends StatefulWidget {
  const Producto({Key? key}) : super(key: key);

  @override
  _ProductoListScreenState createState() => _ProductoListScreenState();
}

class _ProductoListScreenState extends State<Producto> {
  late Database _database;
  late List<Map<String, dynamic>> _productos= [];

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
    _loadProductos();
  }

  Future<void> _loadProductos() async {
    final List<Map<String, dynamic>> productos =
    await _database.query('Producto');
    setState(() {
      _productos = productos;
    });
  }

  Future<void> _addProducto(String nombre, String descripcion, int cantidad, int precio) async {
    final newProducto = {
      'nombre': nombre,
      'precio': precio,
      'cantidad': cantidad,
      'descripcion': descripcion,
    };

    await _database.insert('Producto', newProducto);
    _loadProductos();
  }

  Future<void> _editProducto(int productoId) async {
    // Obtener el Producto actual
    Map<String, dynamic> productoToEdit = _productos.firstWhere(
          (producto) => producto['id'] == productoId,
    );
    String nombre = productoToEdit['nombre'] ?? '';
    String descripcion = productoToEdit['descripcion'] ?? '';
    int precio = productoToEdit['precio'] ?? 0;
    int cantidad = productoToEdit['cantidad'] ?? 0;

    // Mostrar el modal para editar
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _buildEditProductoDialog(nombre, descripcion, cantidad, precio, productoId);
      },
    );
  }

  Future<void> _updateProducto(int productoId, String nombre, String descripcion, int cantidad, int precio) async {
    await _database.update(
      'Producto',
      {'nombre': nombre, 'precio': precio, 'cantidad': cantidad, 'descripcion': descripcion},
      where: 'id = ?',
      whereArgs: [productoId],
    );

    _loadProductos();
  }

  Future<void> _deleteProducto(int productoId) async {
    await _database.delete('Producto', where: 'id = ?', whereArgs: [productoId]);
    _loadProductos();
  }

  @override
  late Color myColor;
  late Size mediaSize;
  Widget build(BuildContext context) {
    myColor = Theme.of(context).primaryColor;
    mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Productos'),
        backgroundColor: Color.fromARGB(255, 42, 104, 44),
      ),
      backgroundColor: Colors.green,
      body: Container(
        color: Colors.white, // Establecer el color de fondo a blanco
        child: ListView.builder(
          itemCount: _productos.length,
          itemBuilder: (context, index) {
            final producto = _productos[index];
            return ListTile(
              title: Text(producto['nombre']),
              subtitle: Text(producto['descripcion']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _editProducto(producto['id']);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteProducto(producto['id']);
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
              return _buildAddProductoDialog();
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddProductoDialog() {
    String nombre = '';
    String descripcion = '';
    int precio = 0;
    int cantidad = 0;

    return AlertDialog(
      title: Text('Agregar Producto'),
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
              descripcion = value;
            },
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              cantidad = int.tryParse(value) ?? 0;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              precio = int.tryParse(value) ?? 0;
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Precio'),
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
            _addProducto(nombre, descripcion, cantidad, precio);
            Navigator.pop(context);
          },
          child: Text('Agregar'),
        ),
      ],
    );
  }

  Widget _buildEditProductoDialog(String nombre, String descripcion, int cantidad, int precio, int productoId) {
    String editedNombre = nombre;
    String editedDescripcion = descripcion;
    int editedPrecio = precio;
    int editedCantidad = cantidad;

    return AlertDialog(
      title: Text('Editar Producto'),
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
              editedDescripcion = value;
            },
            controller: TextEditingController(text: descripcion),
            decoration: InputDecoration(labelText: 'Descripción'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedCantidad = int.tryParse(value) ?? 0;
            },
            controller: TextEditingController(text: cantidad.toString()),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Cantidad'),
          ),
          SizedBox(height: 8),
          TextField(
            onChanged: (value) {
              editedPrecio = int.tryParse(value) ?? 0;
            },
            controller: TextEditingController(text: precio.toString()),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Precio'),
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
            _updateProducto(productoId, editedNombre, editedDescripcion, editedCantidad, editedPrecio);
            Navigator.pop(context);
          },
          child: Text('Guardar'),
        ),
      ],
    );
  }
}
