import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String imagePath; // Nueva propiedad para la ruta de la imagen

  Product({required this.name, required this.price, required this.imagePath});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class Cart {
  final List<CartItem> items = [];
}

class StoreScreen extends StatefulWidget {
  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  final List<Product> products = [
    Product(
        name: 'Amoxi-Tabs C* -250',
        price: 99.0,
        imagePath: 'assets/images/producto1.png'),
    Product(
        name: 'Amoxigentin',
        price: 158.0,
        imagePath: 'assets/images/producto2.png'),
    Product(
        name: 'Nutriderm DHA 400',
        price: 249.0,
        imagePath: 'assets/images/producto3.jpeg'),
    Product(
        name: 'ArtiCan',
        price: 289.0,
        imagePath: 'assets/images/producto4.jpg'),
    Product(
        name: 'Hidramin Oral',
        price: 249.0,
        imagePath: 'assets/images/producto5.jpg'),
    // Añade más productos según sea necesario
  ];

  final Cart cart = Cart();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              // Abre la pantalla del carrito
              _openCartScreen(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
            leading: Image.asset(
              products[index].imagePath,
              height: 50, // ajusta el tamaño según tus necesidades
              width: 50,
            ),
            trailing: IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: () {
                _addToCart(products[index]);
              },
            ),
          );
        },
      ),
    );
  }

  void _addToCart(Product product) {
    setState(() {
      // Busca si el producto ya está en el carrito
      var cartItem = cart.items.firstWhere(
        (item) => item.product.name == product.name,
        orElse: () => CartItem(product: product, quantity: 0),
      );

      if (cartItem.quantity == 0) {
        // Si el producto no está en el carrito, agrégalo
        cart.items.add(CartItem(product: product, quantity: 1));
      } else {
        // Si el producto ya está en el carrito, incrementa la cantidad
        cartItem.quantity++;
      }
    });
  }

  void _openCartScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CartScreen(cart: cart),
      ),
    );
  }
}

class CartScreen extends StatefulWidget {
  final Cart cart;

  CartScreen({required this.cart});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double total = 0.0;

    // Calcular el total a pagar
    for (var item in widget.cart.items) {
      total += item.product.price * item.quantity;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Carrito de Compras'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cart.items.length,
              itemBuilder: (context, index) {
                var item = widget.cart.items[index];
                return ListTile(
                  title: Text(item.product.name),
                  subtitle: Text('\$${item.product.price.toStringAsFixed(2)}'),
                  trailing: Text('Cantidad: ${item.quantity}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total a Pagar: \$${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            // Mostrar el AlertDialog antes de proceder al pago
            _showPaymentDialog(context);
          },
          child: Text('Proceder al Pago'),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Datos de Tarjeta'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _cardNumberController,
                  decoration: InputDecoration(labelText: 'Número de Tarjeta'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el número de tarjeta';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _expiryDateController,
                  decoration:
                      InputDecoration(labelText: 'Fecha de Vencimiento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese la fecha de vencimiento';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cvvController,
                  decoration: InputDecoration(labelText: 'CVV'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese el CVV';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el AlertDialog
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                // Validar el formulario
                if (_formKey.currentState!.validate()) {
                  _proceedToPayment(context);
                  Navigator.pop(context);
                }
              },
              child: Text('Pagar'),
            ),
          ],
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Simulación de pago (puedes agregar tu lógica de pago real aquí)
    _simulatePayment().then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pago exitoso. Carrito limpiado.'),
          ),
        );

        // Limpia el carrito
        widget.cart.items.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('El pago no se pudo procesar. Inténtalo de nuevo.'),
          ),
        );
      }
    });
  }

  Future<bool> _simulatePayment() async {
    // Simulación de procesamiento de pago (puedes agregar tu lógica de pago real aquí)
    await Future.delayed(Duration(seconds: 2));
    return true; // Simulación de pago exitoso
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
