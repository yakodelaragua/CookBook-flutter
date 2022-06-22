import 'package:factura/src/components/recipe_widget.dart';
import 'package:factura/src/connection/server_controller.dart';
import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/recipe.dart';
import '../../flutter_modulo1_fake_backend/user.dart';
import '../components/my_drawer.dart';

class MyFavoritePage extends StatefulWidget {
  final ServerController serverController;

  const MyFavoritePage(this.serverController, {Key? key}) : super(key: key);

  @override
  State<MyFavoritePage> createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis favoritos"),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: widget.serverController.getFavoritesList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Recipe>? list = snapshot.data;

            if(list?.length == 0){
              return SizedBox(  //para que quede alineado al centro
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.info, size: 120, color: Colors.grey[300],),
                      Text("La lista de favoritos está vacía", textAlign: TextAlign.center,)
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                Recipe recipe = list[index];
                return RecipeWidget(recipe: recipe, serverController: widget.serverController, onChange: (){
                  setState(() {
                    
                  });
                });
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

        },
      ),
    );

  }
}
