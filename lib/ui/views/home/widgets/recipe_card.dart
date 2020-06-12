import 'package:flutter/material.dart';
import 'package:recipe_cook_book/app/locator.dart';
import 'package:recipe_cook_book/app/router.dart';
import 'package:recipe_cook_book/constants/themes/theme.dart';

import 'package:recipe_cook_book/ui/views/home/widgets/extentions.dart';
import 'package:recipe_cook_book/constants/themes/light_color.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../core/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final NavigationService _navigationService = locator<NavigationService>();
  RecipeCard({Key key, this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: LightColor.background,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Container(
        child: Hero(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16.0),
                    topLeft: Radius.circular(16.0),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: recipe.imageAssetPath != null
                        ? AssetImage(recipe.imageAssetPath)
                        : NetworkImage(recipe.imageUrl),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    recipe.recipeTitle,
                    style: AppTheme.h2Style.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                    maxLines: 4,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.timer,
                      size: 16,
                    ),
                    SizedBox(width: 3),
                    Expanded(
                      child: Text('Ready in ${recipe.readyInMinutes} minutes'),
                    ),
                  ],
                ),
              ),
            ],
          ),
          tag: recipe.recipeId,
        ),
      ).ripple(() {
        _navigationService.navigateTo(Routes.recipeDetailsViewRoute,
            arguments: recipe);
      }, borderRadius: BorderRadius.all(Radius.circular(20))),
    );
  }
}
