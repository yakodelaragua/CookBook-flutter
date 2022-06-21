import 'package:factura/flutter_modulo1_fake_backend/modulo1_fake_backend.dart' as server;
import 'package:factura/flutter_modulo1_fake_backend/models.dart';
import 'package:flutter/material.dart';

class ServerController{
  void init(BuildContext context){ //fake backend, esto seria la conexion al servidor, base de datos...
    server.generateData(context);
  }

  Future<User?> login(String userName, String password) async {
    return await server.backendLogin(userName, password);
  }
}