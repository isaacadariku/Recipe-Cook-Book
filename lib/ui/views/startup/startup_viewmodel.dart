import 'package:recipe_cook_book/app/locator.dart';
import 'package:recipe_cook_book/app/router.dart';
import 'package:recipe_cook_book/core/services/storage_util_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  
  final NavigationService _navigationService = locator<NavigationService>();
  
  // TODO: loading,

  Future setup() async {
    await locator.allReady();
    if (!locator<StorageUtil>().getBool('HAS_BEEN_INTRODUCED'))
      await _navigationService.replaceWith(Routes.onboardingViewRoute);
    else _navigationService.clearStackAndShow(Routes.homeViewRoute);
  }
}