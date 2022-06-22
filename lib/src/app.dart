import 'package:factura/src/connection/server_controller.dart';
import 'package:factura/src/screens/home_page.dart';
import 'package:factura/src/screens/login_page.dart';
import 'package:factura/src/screens/my_favorites_page.dart';
import 'package:factura/src/screens/register_page.dart';
import 'package:flutter/material.dart';

import '../flutter_modulo1_fake_backend/user.dart';

ServerController _serverController = ServerController();

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Factura',
      theme: ThemeData(
        brightness: Brightness.light, //Tema claro
        primaryColor: Colors.cyan[400],
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 22),
        ),
      ),
      //home: MyHomePage(),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (BuildContext context) {
          switch (settings.name) {
            case "/":
              return LoginPage(_serverController, context);
            case "/home":
              User loggedUser = settings.arguments as User;
              _serverController.loggedUser = loggedUser;
              return HomePage(_serverController);
            case "/register":
              User loggedUser = settings.arguments as User;
              return RegisterPage(
                _serverController,
                context,
                userToEdit: loggedUser,
              );
            case "/favorites":
              User loggedUser = settings.arguments as User;
              return MyFavoritePage(
                _serverController
              );
            default:
              return LoginPage(_serverController, context);
          }
        });
      },
      //routes: {
      //  "/":(BuildContext context)=> LoginPage(_serverController),
      //  },
    );
  }
}
