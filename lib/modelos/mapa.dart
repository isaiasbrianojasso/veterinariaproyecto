import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaScreen extends StatefulWidget {
  @override
  _MapaScreenState createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  GoogleMapController? _mapController;

  // Marcadores para las sucursales
  Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('sucursal1'),
      position: LatLng(37.7749, -122.4194), // Coordenadas de la Sucursal 1
      infoWindow: InfoWindow(title: 'Sucursal 1'),
    ),
    Marker(
      markerId: MarkerId('sucursal2'),
      position: LatLng(37.7749, -122.4294), // Coordenadas de la Sucursal 2
      infoWindow: InfoWindow(title: 'Sucursal 2'),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de Sucursales'),
        // Agregar el botón de retroceso en el AppBar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Volver a la pantalla anterior
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(37.7749, -122.4194), // Coordenadas iniciales del mapa
          zoom: 12.0,
        ),
        markers: _markers,
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Flutter',
      home: MapaScreen(),
    );
  }
}
