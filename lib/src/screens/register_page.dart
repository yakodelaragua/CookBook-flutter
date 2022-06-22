import 'dart:io';

import 'package:factura/src/components/image_picker_widget.dart';
import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/user.dart';
import '../connection/server_controller.dart';

class RegisterPage extends StatefulWidget {
  ServerController serverController;
  BuildContext context;

  //Segun desde donde se abra la pagina de registro
  User userToEdit;

  RegisterPage(this.serverController, this.context, {Key? key, required this.userToEdit})
      : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String userName = "";
  String password = "";

  Genrer genrer = Genrer.MALE;

  bool showPassword = false;
  String _errorMessage = "";


  File imageFile = File("");
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffKey = GlobalKey<ScaffoldState>();

  //Segun desde donde se abra la pagina de registro
  bool editingUser = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey, //para tener acceso
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
              imageFile: this.imageFile,
              onImageSelected: (File file) {
                setState(() {
                  imageFile = file;
                });
              },
            ),
            SizedBox(
              child: AppBar(
                //barra transparente con icono blanco
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              height: kToolbarHeight + 25,
            ),
            Center(
              child: SingleChildScrollView(
                child: Transform.translate(
                  offset: const Offset(0, -40),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, top: 260, bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 35, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            initialValue: userName,
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
                            initialValue: password,
                            decoration: InputDecoration(
                                labelText: "Contraseña: ",
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                )),
                            obscureText: !showPassword,
                            onSaved: (value) {
                              password = value!;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Campo obligatorio";
                              }
                            },
                          ), //pass
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Género",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700]),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    RadioListTile(
                                      title: Text(
                                        "Masculino",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      value: Genrer.MALE,
                                      groupValue: genrer,
                                      onChanged: (value) {
                                        setState(() {
                                          genrer = value!;
                                        });
                                      },
                                    ),
                                    RadioListTile(
                                      title: Text(
                                        "Femenino",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      value: Genrer.FEMALE,
                                      groupValue: genrer,
                                      onChanged: (value) {
                                        setState(() {
                                          genrer = value!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _doProcess(context);
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(editingUser?"Actualizar": "Registrar"),
                                //Text("Registrar"),
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

  void _doProcess(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (imageFile == null) {
        showSnackBar(context, "Selecciona una imagen", Colors.orange);
        return ;
      }
      User user = User(nickname: this.userName, password: this.password, genrer: this.genrer, photo: this.imageFile, id: 1);
      var state;
      if (editingUser) {
        user.id = widget.serverController.loggedUser.id;
        state = await widget.serverController.updateUser(user);

      } else {
        state = await widget.serverController.addUser(user);
      }

      final action = editingUser?"actualizar":"guardar";
      final action2 = editingUser?"actualizado":"guardado";

      if (state == false) {
        showSnackBar(context, "No se pudo $action", Colors.orange);
      } else {
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: Text("Información"),
            content: Text("Su usuario ha sido $action2 exitosamente"),
            actions: <Widget> [
              TextButton(onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
                  child: Text("Ok")),
            ],
          );
        });
      }
    }
  }

  void showSnackBar(BuildContext context, String title, Color backcolor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
        backgroundColor: backcolor,
      ),
    );
  }

  void initState() {
    super.initState();
    editingUser = (widget.userToEdit != null);
    if(editingUser) {
      userName = widget.userToEdit.nickname;
      password = widget.userToEdit.password;
      imageFile = widget.userToEdit.photo;
      genrer = widget.userToEdit.genrer;
    }
  }

  void _update(BuildContext context) {}
}
