import 'package:factura/src/components/image_picker_widget.dart';
import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/user.dart';
import '../connection/server_controller.dart';

class RegisterPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;
  RegisterPage(this.serverController, this.context, {Key? key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String userName = "";
  String password = "";
  String _errorMessage = "";

  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: _formKey, //para tener acceso
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 60),
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.cyan[300]!, Colors.cyan[800]!])),
                  
            ),
            SizedBox(child: AppBar( //barra transparente con icono blanco
              elevation: 0,
              backgroundColor: Colors.transparent,

            ), height: kToolbarHeight + 25,),
            Transform.translate(
              offset: Offset(0, -40),
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
                            },
                          ), //form texto normal
                          SizedBox(
                            height: 40,
                          ), //anadir espacio
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Contraseña: "),
                            obscureText: true,
                            onSaved: (value) {
                              password = value!;
                            },
                          ), //pass
                          SizedBox(
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
                                Text("Iniciar sesión"),
                                if (_loading)
                                  Container(
                                    height: 20,
                                    width: 20,
                                    margin: EdgeInsets.only(left: 20),
                                    child: CircularProgressIndicator(
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
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          SizedBox(
                            height: 20,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("¿No estás registrado?"),
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

  void _showRegister(BuildContext context) async {
    Navigator.of(context).pushNamed('/register');
  }

  @override
  void initState() {
    //inicializar datos
    super.initState();
    widget.serverController.init(widget.context);
  }
}
