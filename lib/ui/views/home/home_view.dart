import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_cook_book/ui/views/home/widgets/searchbar.dart';
import 'package:stacked/stacked.dart';

import 'package:recipe_cook_book/constants/colors.dart';
import 'package:recipe_cook_book/constants/themes/theme.dart';
import 'home_viewmodel.dart';
import 'package:recipe_cook_book/ui/views/home/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:recipe_cook_book/ui/views/home/widgets/recipe_card.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Theme(
        data: Theme.of(context).copyWith(
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),
        child: Scaffold(
          backgroundColor: Color(0xffefefef),
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    model.title,
                    style: AppTheme.h1Style.copyWith(
                      color: ThemeColors.lightOrange1,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(height: 24),
                  model.selectedIndex == 1
                      ? Container()
                      : SearchBar(func: model.search),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        model.isBusy
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1 / 1.5,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return RecipeCard(
                                    recipe: model.recipes[index],
                                  );
                                },
                                itemCount: model.recipes != null
                                    ? model.recipes.length
                                    : 0,
                                shrinkWrap: true,
                                primary: false,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomSheet: CustomBottomNavigationBar(
            icon1: Icons.home,
            icon2: Icons.favorite,
            onIconPresedCallback: model.bottomNavbarPressed,
            selectedIndex: model.selectedIndex,
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
