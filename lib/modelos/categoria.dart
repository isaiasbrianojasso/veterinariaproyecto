class Categoria {
  int id;
  String nombre;
  String foto;

  Categoria(this.id, this.nombre, this.foto);
}

final Menu = [
  Categoria(1, "Citas", "citas.png"),
  Categoria(2, "Tienda", "tienda.png"),
  Categoria(3, "Sucursales", "mapa.png"),
  Categoria(4, "Nosotros", "info.png"),
];
