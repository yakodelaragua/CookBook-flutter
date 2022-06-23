import 'package:factura/src/connection/server_controller.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final ServerController serverController;
  const MyDrawer({Key? key, required this.serverController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://media.istockphoto.com/photos/forest-wooden-table-background-summer-sunny-meadow-with-green-grass-picture-id1353553203?b=1&k=20&m=1353553203&s=170667a&w=0&h=QTyTGI9tWQluIlkmwW0s7Q4z7R_IT8egpzzHjW3cSas="),
                      fit: BoxFit.cover)),
              accountName: Text(
                serverController.loggedUser.nickname,
                style: TextStyle(color: Colors.white),
              ),
              accountEmail: Text(serverController.loggedUser.nickname),
              currentAccountPicture: CircleAvatar(
                backgroundImage: FileImage(serverController.loggedUser.photo),
              ),
              onDetailsPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/register",
                    arguments: serverController.loggedUser);
              }),
          ListTile(
            //Botones de la lista lateral
            title: Text(
              "Mis recetas",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.book,
              color: Colors.green,
            ),

            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed("/my_recipes");
            },
          ),
          ListTile(
            title: Text(
              "Mis favoritos",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.of(context).pushNamed("/favorites");

            },
          ),
          ListTile(
            title: Text(
              "Cerrar sesión",
              style: TextStyle(fontSize: 18),
            ),
            leading: Icon(
              Icons.power_settings_new,
              color: Colors.cyan,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/");
            },
          ),
        ],
      ),
    );
  }
}
