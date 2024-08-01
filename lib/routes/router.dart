import 'package:auto_route/auto_route.dart';
import 'package:firebasebloc/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRoute extends $AppRoute {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: SignUpRoute.page),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: ProfileRoute.page),
    AutoRoute(page: CreateProfileRoute.page),
    AutoRoute(page: UserHomeRoute.page)
  ];
}
