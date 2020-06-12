import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:recipe_cook_book/app/locator.dart';
import 'package:recipe_cook_book/constants/colors.dart';
import 'package:recipe_cook_book/constants/themes/light_color.dart';
import 'package:recipe_cook_book/constants/themes/theme.dart';
import 'package:recipe_cook_book/core/models/recipe.dart';
import 'package:recipe_cook_book/core/services/saved_recipes.dart';
import 'package:recipe_cook_book/ui/views/home/widgets/title_text.dart';
import 'package:recipe_cook_book/ui/views/widgets/custom_appbar_icon.dart';

class RecipeDetailView extends StatefulWidget {
  RecipeDetailView({Key key}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<RecipeDetailView>
    with TickerProviderStateMixin {
  SavedRecipesService _saved = locator<SavedRecipesService>();
  Recipe recipe;
  bool isLiked;

  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _fancyDivider() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _colorWidget(LightColor.yellowColor),
              _colorWidget(LightColor.lightBlue),
              _colorWidget(LightColor.black),
              _colorWidget(LightColor.red),
              _colorWidget(LightColor.skyBlue),
            ],
          )
        ],
      ),
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
              Icons.check_circle,
              color: color,
              size: 18,
            )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  List<Ingredient> getIngredients(Recipe recipe) {
    Set<Ingredient> ing = Set<Ingredient>();
    for (Step step in recipe.analyzedInstructions.first?.steps) {
      ing.addAll(step.ingredients);
    }

    return ing.toList();
  }

  @override
  Widget build(BuildContext context) {
    recipe = ModalRoute.of(context).settings.arguments;
    isLiked = _saved.isSaved(recipe.recipeId);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Details',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        actions: <Widget>[
          isLiked
              ? IconButton(
                  icon: Icon(Icons.favorite),
                  color: LightColor.red,
                  onPressed: () async {
                    await _saved.removeRecipe(recipe.recipeId);
                    setState(() {});
                  },
                )
              : IconButton(
                  icon: Icon(Icons.favorite_border),
                  color: LightColor.black,
                  onPressed: () async {
                    await _saved.addRecipe(recipe.recipeId);
                    setState(() {
                      isLiked = _saved.isSaved(recipe.recipeId);
                    });
                  },
                ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: <Widget>[
            ImageBanner(
              imageAssetPath: recipe.imageAssetPath,
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
                top: 16.0,
              ),
              child: Text(
                recipe.recipeTitle,
                style: AppTheme.h1Style,
              ),
            ),
            // Divider(
            //   color: Colors.black54,
            // ),
            _fancyDivider(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: IngredientsSection(
                ingredients: getIngredients(recipe),
              ),
            ),
            _fancyDivider(),
            // Divider(
            //   color: Colors.black54,
            // ),
            Padding(
              child: InstructionsSection(
                instructions: recipe.analyzedInstructions.first?.steps,
              ),
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            )
          ],
        ),
      ),
    );
  }
}

class NumberedTile extends StatelessWidget {
  final int number;
  final Widget content;

  const NumberedTile({Key key, this.number, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Chip(
        label: Text(number.toString()),
        shape: CircleBorder(
          side: BorderSide(
            color: ThemeColors.searchBarIcon,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        labelPadding: EdgeInsets.all(6.0),
      ),
      title: content,
    );
  }
}

class ImageBanner extends StatelessWidget {
  final String imageAssetPath;

  const ImageBanner({Key key, this.imageAssetPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Image.asset(
        imageAssetPath,
        fit: BoxFit.cover,
      ),
    );
  }
}

class IngredientsSection extends StatelessWidget {
  final List<Ingredient> ingredients;

  const IngredientsSection({Key key, this.ingredients}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Ingredients',
          style: AppTheme.h2Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            return NumberedTile(
              number: index + 1,
              content: Text(
                ingredients[index].name,
                style: AppTheme.h3Style,
              ),
            );
          },
          itemCount: ingredients.length,
        ),
      ],
    );
  }
}

class InstructionsSection extends StatelessWidget {
  final List<Step> instructions;

  const InstructionsSection({Key key, this.instructions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Instructions',
          style: AppTheme.h2Style.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 16.0),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemBuilder: (_, int index) {
            return Card(
              child: NumberedTile(
                number: index + 1,
                content: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    instructions[index].step,
                    style: AppTheme.subTitleStyle.copyWith(
                      color: Color(0xff777777),
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              margin: EdgeInsets.symmetric(vertical: 4.0),
              shadowColor: Color(0xffffffff),
            );
          },
          itemCount: instructions.length,
        ),
      ],
    );
  }
}
