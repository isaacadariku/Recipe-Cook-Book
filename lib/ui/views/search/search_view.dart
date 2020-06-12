import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'search_viewmodel.dart';
import 'package:recipe_cook_book/ui/views/home/widgets/recipe_card.dart';

class SearchView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
        builder: (context, model, child) {
      // return CupertinoPageScaffold(
      //   navigationBar: CupertinoNavigationBar(
      //     leading: AppBarCustomIcon(
      //       icon: Icons.arrow_back_ios,
      //       color: Colors.black54,
      //       size: 15,
      //       padding: 12,
      //       isOutLine: true,
      //       onPressed: model.popView,
      //     ),
      //     //leading: Icon(Icons.arrow_back_ios),
      //     backgroundColor: ThemeColors.background,
      //     middle: Text(model.title),
      //   ),
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: model.popView,
          ),
          title: Text(
            model.title,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          brightness: Brightness.light,
        ),
        backgroundColor: Color(0xffefefef),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        padding: EdgeInsets.all(16.0),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1 / 1.6,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return RecipeCard(
                            recipe: model.data[index],
                          );
                        },
                        itemCount: model.data?.length ?? 0,
                      ),
              ),
            ],
          ),
        ),
        //),
      );
    }, viewModelBuilder: () {
      String keyword = ModalRoute.of(context).settings.arguments;
      return SearchViewModel(keyword);
    });
  }
}
