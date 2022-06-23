import 'package:flutter/material.dart';

import '../../flutter_modulo1_fake_backend/recipe.dart';

class TabIngredientsWidget extends StatelessWidget {
  final Recipe recipe;
  const TabIngredientsWidget({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      children: <Widget>[
        Text(recipe.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        SizedBox(
          height: 10,
        ),
        Text(recipe.description, style: TextStyle(fontSize: 16,),),
        SizedBox(
          height: 10,
        ),
        Text("Ingredientes", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        SizedBox(
          height: 15,
        ),
        Column(
          children: List.generate(recipe.ingredients.length, (int index) { //Como un foreach!!!!!!!!!!!!!!!!!!!!!!!!!!
            final ingredient = recipe.ingredients[index];
            return ListTile(
              leading: Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              title: Text(ingredient),
            );
          }),
        )

      ],
    );
  }
}
