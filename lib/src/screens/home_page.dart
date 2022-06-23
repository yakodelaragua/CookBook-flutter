import 'package:factura/src/components/recipe_widget.dart';
import 'package:factura/src/connection/server_controller.dart';
import 'package:factura/src/screens/add_recipe_page.dart';
import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/recipe.dart';
import '../../flutter_modulo1_fake_backend/user.dart';
import '../components/my_drawer.dart';

class HomePage extends StatefulWidget {
  final ServerController serverController;

  const HomePage(this.serverController, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cookbook"),
      ),
      drawer: MyDrawer(serverController: widget.serverController,),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getRecipesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final list = snapshot.data;
            return ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(recipe: recipe, serverController: widget.serverController, onChange: () {setState(() {

                });});
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.of(context).pushNamed("/add_recipe");
        },
      ),
    );

  }
}
