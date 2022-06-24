import 'dart:io';

import 'package:factura/src/components/image_picker_widget.dart';
import 'package:factura/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../flutter_modulo1_fake_backend/recipe.dart';
import '../components/ingredient_widget.dart';
import 'add_recipe_page.dart';

class AddRecipePage extends StatefulWidget {
  final ServerController serverController;
  final Recipe? recipe;

  const AddRecipePage({required this.serverController, Key? key, this.recipe})
      : super(key: key);
  @override
  State<AddRecipePage> createState() => _AddRecipePageState();
}

class _AddRecipePageState extends State<AddRecipePage> {
  String name = "";
  String descripcion = "";
  File imageFile = File("");

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  List<String> ingredientsList = [], stepsList = [];
  bool editing = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
    body: Form(
      key: formKey,
        child: Stack(
          children: <Widget>[
            ImagePickerWidget(
                imageFile: this.imageFile,
                onImageSelected: (File file) {
                  setState(() {
                    imageFile = file;
                  });
                }),
            SizedBox(
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                iconTheme: IconThemeData(color: Colors.white),
                actions: <Widget>[
                  IconButton(onPressed: () {
                   _save(context);
                  }, icon: Icon(Icons.save))
                ],
              ),
            ),
            Center(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 260, bottom: 20),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: name,
                        decoration:
                            InputDecoration(labelText: "Nombre de receta"),
                        onSaved: (value) {
                          this.name = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "El campo no puede estar vacio";
                          }
                        },
                      ),
                      TextFormField(
                        initialValue: descripcion,
                        decoration: InputDecoration(labelText: "Descripción"),
                        onSaved: (value) {
                          this.descripcion = value!;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "El campo no puede estar vacio";
                          }
                        },
                        maxLines: 6,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text("Ingredientes"),
                        trailing: FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            _ingredientDialog(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getIngredientsList(),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text("Pasos"),
                        trailing: FloatingActionButton(
                          child: Icon(Icons.add),
                          onPressed: () {
                            _stepDialog(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      getStepsList(),
                      SizedBox(
                      height: 20,
                    ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
    Widget getStepsList() {
      if (stepsList.length == 0) {
        return Text(
          "Listado vacío",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return Column(
          children: List.generate(stepsList.length, (index) {
            final ingredient = stepsList[index];
            return IngredientWidget(
              index: index,
              ingredientName: ingredient,
              onIngredientDeleteCallback: _onStepDelete,
              onIngredientEditCallback: _onStepEdit,
            );
          }),
        );
      }
    }

    Widget getIngredientsList() {
      if (ingredientsList.length == 0) {
        return Text(
          "Listado vacío",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        );
      } else {
        return Column(
          children: List.generate(ingredientsList.length, (index) {
            final ingredient = ingredientsList[index];
            return IngredientWidget(
              index: index,
              ingredientName: ingredient,
              onIngredientDeleteCallback: _onIngredientDelete,
              onIngredientEditCallback: _onIngredientEdit,
            );
          }),
        );
      }
    }
  void _save(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (imageFile == null) {
        _showSnackBar("La imágen está vacía");
        return;
      }
      if (ingredientsList.length == 0) {
        _showSnackBar("No tiene ingredientes");
        return;
      }
      if (stepsList.length == 0) {
        _showSnackBar("No tiene pasos");
        return;
      }

      final recipe = Recipe(
          name: this.name,
          description: this.descripcion,
          ingredients: this.ingredientsList,
          steps: this.stepsList,
          photo: this.imageFile,
          user: widget.serverController.loggedUser,
          date: DateTime.now(), id: 1);

      bool saved = false;
      if(editing){
        saved = await widget.serverController.updateRecipe(recipe);
      } else {
        final recipe2 = await widget.serverController.addRecipe(recipe);
        saved = recipe2 != null;
      }

      if (saved) {
        Navigator.pop(context, recipe);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Receta guardada exitosamente"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      } else {
        _showSnackBar("No se pudo realizar");
      }
    }
  }

  void _showSnackBar(String message, {Color backColor = Colors.black}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backColor,
      ),
    );
  }

  //agregar y editar
  void _ingredientDialog(BuildContext context, {String ?ingredient, int ?index}) {
    final textController = TextEditingController(text: ingredient);
    final editing = ingredient != null;
    final onSave = () {
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar("El nombre está vacío", backColor: Colors.orange);
      } else {
        setState(() {
          if (index != null && editing) {
            ingredientsList[index] = text;
          } else {
            ingredientsList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
                editing ? "Editando ingrediente" : "Agregando ingrediente"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(labelText: "Ingrediente"),
              onEditingComplete: onSave,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(editing ? "Actualizar" : "Guardar"),
                onPressed: onSave,
              ),
            ],
          );
        });
  }

  void _stepDialog(BuildContext context, {String ?step, int ?index}) {
    final textController = TextEditingController(text: step);
    final editing = step != null;
    final onSave = () {
      final text = textController.text;
      if (text.isEmpty) {
        _showSnackBar("El paso está vacío", backColor: Colors.orange);
      } else {
        setState(() {
          if (index != null && editing) {
            stepsList[index] = text;
          } else {
            stepsList.add(text);
          }
          Navigator.pop(context);
        });
      }
    };

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(editing ? "Editando paso" : "Agregando paso"),
            content: TextField(
              controller: textController,
              decoration: InputDecoration(
                labelText: "Paso",
              ),
              textInputAction: TextInputAction.newline,
              maxLines: 6,
              //onEditingComplete: onSave,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text(editing ? "Actualizar" : "Guardar"),
                onPressed: onSave,
              ),
            ],
          );
        });
  }

  void _onIngredientEdit(int index) {
    final ingredient = ingredientsList[index];
    _ingredientDialog(context, ingredient: ingredient, index: index);
  }

  void _onIngredientDelete(int index) {
    questionDialog(context, "¿Seguro que quieres eliminar el ingrediente?", () {
      setState(() {
        ingredientsList.removeAt(index);
      });
    });
  }

  void _onStepEdit(int index) {
    final step = stepsList[index];
    _stepDialog(context, step: step, index: index);
  }

  void _onStepDelete(int index) {
    questionDialog(context, "¿Seguro desea eliminar el paso?", () {
      setState(() {
        stepsList.removeAt(index);
      });
    });
  }
  void questionDialog(BuildContext context, String message, VoidCallback onOk) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(message),
            actions: <Widget>[
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Si"),
                onPressed: () {
                  Navigator.pop(context);
                  onOk();
                },
              ),
            ],
          );
        });
  }

  void initState(){
    super.initState();
    editing = widget.recipe != null;
    if(editing) {
      name = widget.recipe!.name;
      descripcion = widget.recipe!.description;
      ingredientsList = widget.recipe!.ingredients;
      stepsList = widget.recipe!.steps;
      imageFile = widget.recipe!.photo;
    }
  }

}


