import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

import 'package:sqlite/model/client_model.dart';

class ClientDatabaseProvider {
  ClientDatabaseProvider._();

  static final ClientDatabaseProvider db = ClientDatabaseProvider._();
  Database _database;

  // para evitar que se abran varias conexiones
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  Future<Database> getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "client.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Clients ( '
          'id INTEGER PRIMARY KEY, '
          'name TEXT, '
          'phone TEXT) ');
    });
  }

  // Query Muestra todos los clientes de la base de datos
  Future<List<Client>> getAllClients() async {
    final db = await database;
    var response = await db.query('Clients');
    List<Client> list = response.map((c) => Client.fromMap(c)).toList();
    return list;
  }

  // Query para obtener solo un cliente
  Future<Client> getClientById(int id) async {
    final db = await database;
    var response = await db.query('Clients', where: 'id = ?', whereArgs: [id]);
    List<Client> list = response.map((c) => Client.fromMap(c));
    return response.isNotEmpty ? Client.fromMap(response.first) : null;
  }

  // Insert data
  addClient(Client client) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Clients");

    int id = table.first["id"];
    client.id = id;
    var raw = await db.insert('Clients', client.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return raw;
  }

  // Delete Client with id
  deleteClientById(int id) async {
    final db = await database;
    return db.delete("Clients", where: 'id = ?', whereArgs: [id]);
  }

  //Delete all clientes
  deleteClientData() async {
    final db = await database;
    return db.delete("Clients");
  }

  // Update client
  updateClient(Client client) async {
    final db = await database;
    var response = await db.update('Clients', client.toMap(),
        where: 'id = ?', whereArgs: [client.id]);
    return response;
  }
}
