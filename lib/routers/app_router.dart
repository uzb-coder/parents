import 'package:parents/library/librarys.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String payemnts = '/payments';
  static const String grade = '/grades';
  static const String daily = '/daily';
  static const String splash = '/splash';
  static const String profil = '/profile';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => LoginPage(),
    AppRoutes.home: (context) => MainScreen(),
    AppRoutes.payemnts: (context) => Payments(),
    AppRoutes.grade: (context) => GradePage(),
    AppRoutes.daily: (context) => DailyPage(),
    AppRoutes.splash: (context) => SplashPage(),
    AppRoutes.profil: (context) => ProfilePage(),
  };
}
