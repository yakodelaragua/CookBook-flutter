import 'package:factura/src/components/tab_ingredients_widget.dart';
import 'package:factura/src/components/tab_preparation_widget.dart';
import 'package:factura/src/connection/server_controller.dart';
import 'package:flutter/material.dart';
import '../../flutter_modulo1_fake_backend/recipe.dart';

class DetailsPage extends StatefulWidget {
  Recipe recipe;
  final ServerController serverController;
  DetailsPage({Key? key, required this.serverController, required this.recipe}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool favorite = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView( //iamgen grande y cuando se hace scroll hacia arriba s e disminuye el tamaño
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled){
            return [SliverAppBar(
              title: Text(widget.recipe.name),
              expandedHeight: 320,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover, image: FileImage(widget.recipe.photo)
                  ),
                ),
              ),
              pinned: true, //que no suba la imagen entera
              bottom: TabBar(
                labelColor: Colors.white,
                tabs: <Widget> [
                  Tab(
                    child: Text("Ingredientes",
                    style: TextStyle(fontSize: 18,),),
                  ),
                  Tab(
                    child: Text("Preparación",
                      style: TextStyle(fontSize: 18),),
                  )
                ],
              ),
              actions: <Widget>[  //botones de la barra de arriba
                if(widget.recipe.user.id == widget.serverController.loggedUser.id)
                  IconButton(onPressed: () async {
                    final nRecipe = await Navigator.of(context).pushNamed("/edit_recipe", arguments: widget.recipe);
                    setState(() {
                      widget.recipe = nRecipe as Recipe;
                    });
                  }, icon: Icon(Icons.edit)),


                getFavoriteWidget(),
                IconButton(onPressed: (){}, icon: Icon(Icons.help)),

              ],
            )

            ];
          }, body: TabBarView(
          children: <Widget>[
            TabIngredientsWidget(recipe: widget.recipe),
            TabPreparationWidget(recipe: widget.recipe),

          ],
        ),
        ),

      ),
    );
  }
  Widget getFavoriteWidget(){
    if(favorite != null) {
      if(favorite){
        return
            IconButton(onPressed: () async {
              widget.serverController.deleteFavorite(widget.recipe);
              setState(() {
                favorite = false;
              });
            }, icon: Icon(Icons.favorite), color: Colors.red,);
      } else {
        return
          IconButton(onPressed: () async {
            widget.serverController.addFavorite(widget.recipe);
            setState(() {
              favorite = true;
            });
          }, icon: Icon(Icons.favorite_border), color: Colors.white,);
      }
    } else {
      return Container(
          margin: EdgeInsets.all(15),
          width: 30,
          child: CircularProgressIndicator());
    }
  }
//Para poder solicitar esa info al inicializar el estado
  void initState() {
    super.initState();
    loadState();
  }

  void loadState() async {
    final state = await widget.serverController.getIsFavorite(widget.recipe);
    setState(() {
      this.favorite = state;
    });
  }
}
