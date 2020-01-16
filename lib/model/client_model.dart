class Client {
  int id;
  String name;
  String phone;
  Client({this.id, this.name, this.phone});

  // Para Insertar datos a la BD, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {"id": id, "name": name, "phone": phone};

  // Para recibir los datos necesitamos pasar de Map a JSON
  factory Client.fromMap(Map<String, dynamic> json) =>
      new Client(id: json['id'], name: json['name'], phone: json['phone']);
}
