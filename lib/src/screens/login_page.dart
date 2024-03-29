import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/user.dart';
import '../connection/server_controller.dart';

class LoginPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  LoginPage(this.serverController, this.context, {Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userName = "";
  String password = "";
  String _errorMessage = "";

  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, //para tener acceso
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 60),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.cyan[300]!, Colors.cyan[800]!])),
              child: Image.asset(
                "/images/logo.png",
                color: Colors.white,
                height: 200,
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -40),
              child: Center(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(
                      left: 20, right: 20, top: 260, bottom: 20),
                  child: SingleChildScrollView(
                    //para solucionar error porque la lista se sale de la view
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Usuario: "),
                            onSaved: (value) {
                              userName = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              }
                              return null;
                            },
                          ), //form texto normal
                          const SizedBox(
                            height: 40,
                          ), //anadir espacio
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Contraseña: "),
                            obscureText: true,
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if(value!.isEmpty) {
                                return "Campo obligatorio";
                              }
                              return null;
                            },
                          ), //pass
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _login(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text("Iniciar sesión"),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: const EdgeInsets.only(left: 20),
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  )
                              ],
                            ),
                          ),
                          if (_errorMessage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _errorMessage,
                                style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(
                            height: 20,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Text("¿No estás registrado?"),
                              TextButton(
                                onPressed: () {
                                  _showRegister(context);
                                },
                                child: Text("Registrarse"),
                                style: TextButton.styleFrom(
                                    primary: Theme.of(context).primaryColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _login(BuildContext context) async {
    if (!_loading) {
      if (_formKey.currentState!.validate()) {
        //Siempre en el formulario
        _formKey.currentState!.save(); //guardar form
        setState(() {
          _loading = true;
          _errorMessage = "";
        });

        User? user = await widget.serverController
            .login(userName, password); //coger usuario del form
        if (user != null) {
          //si existe en la base de datos
          Navigator.of(context).pushReplacementNamed("/home",
              arguments:
                  user); //mostrar la siguiente pantalla pero no deja volver atras, habria que cerrar sesion
        } else {
          //si no existe
          setState(() {
            _errorMessage = "Usuario o contraseña incorrecta";
            _loading = false; //deja de cargar la rueda
          });
        }
      }
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  void initState() {
    //inicializar datos
    super.initState();
    widget.serverController.init(widget.context);
  }
}
