// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:firebasebloc/modules/login/screens/login_screen.dart' as _i2;
import 'package:firebasebloc/modules/profile/screens/create_profile.dart'
    as _i1;
import 'package:firebasebloc/modules/signup/screens/sign_up_screen.dart' as _i3;
import 'package:firebasebloc/modules/user_home/screens/user_home_screen.dart'
    as _i5;
import 'package:firebasebloc/splash_screen.dart' as _i4;

abstract class $AppRoute extends _i6.RootStackRouter {
  $AppRoute({super.navigatorKey});

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    CreateProfileRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i1.CreateProfileScreen()),
      );
    },
    LoginRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i2.LoginScreen()),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i3.SignUpScreen()),
      );
    },
    SplashRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SplashScreen(),
      );
    },
    UserHomeRoute.name: (routeData) {
      return _i6.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.WrappedRoute(child: const _i5.UserHomeScreen()),
      );
    },
  };
}

/// generated route for
/// [_i1.CreateProfileScreen]
class CreateProfileRoute extends _i6.PageRouteInfo<void> {
  const CreateProfileRoute({List<_i6.PageRouteInfo>? children})
      : super(
          CreateProfileRoute.name,
          initialChildren: children,
        );

  static const String name = 'CreateProfileRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i6.PageRouteInfo<void> {
  const LoginRoute({List<_i6.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SignUpScreen]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SplashScreen]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute({List<_i6.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}

/// generated route for
/// [_i5.UserHomeScreen]
class UserHomeRoute extends _i6.PageRouteInfo<void> {
  const UserHomeRoute({List<_i6.PageRouteInfo>? children})
      : super(
          UserHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'UserHomeRoute';

  static const _i6.PageInfo<void> page = _i6.PageInfo<void>(name);
}
