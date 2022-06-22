import 'dart:async';

import 'package:factura/flutter_modulo1_fake_backend/modulo1_fake_backend.dart' as server;
import 'package:factura/flutter_modulo1_fake_backend/models.dart';
import 'package:flutter/material.dart';

class ServerController{

  late User loggedUser;

  void init(BuildContext context){ //fake backend, esto seria la conexion al servidor, base de datos...
    server.generateData(context);
  }

  Future<User?> login(String userName, String password) async {
    return await server.backendLogin(userName, password);
  }

  Future<bool> addUser(User nUser) async {
    return await server.addUser(nUser);
  }

  Future<List<Recipe>> getRecipesList() async {
    return await server.getRecipes();
  }

  Future<bool> getIsFavorite(Recipe recipeToCheck) async {
    return await server.isFavorite(recipeToCheck);
  }

  Future<Recipe> addFavorite(Recipe nFavorite) async {
    return await server.addFavorite(nFavorite);
  }
  Future<bool> deleteFavorite(Recipe nFavorite) async {
    return await server.deleteFavorite(nFavorite);
  }

  Future<bool> updateUser(User user) async {
    loggedUser = user;
    return await server.updateUser(user);
  }

  Future<List<Recipe>> getFavoritesList() async {
    return await server.getFavorites();
  }

}