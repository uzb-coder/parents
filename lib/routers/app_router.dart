import 'package:parents/scr/home/navigator.dart';
import 'package:parents/scr/menu/daily.dart';
import 'package:parents/scr/menu/grade.dart';
import 'package:parents/scr/menu/payments.dart';

import '../../library/librarys.dart';

class AppRoutes {
  static const String login = '/';
  static const String home = '/home';
  static const String payemnts = '/payments';
  static const String Grade = '/grades';
  static const String Daily = '/daily';
}

class AppRouter {
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => LoginPage(),
    AppRoutes.home: (context) => MainScreen(),
    AppRoutes.payemnts: (context) => Payments(),
    AppRoutes.Grade: (context) => Grade(),
    AppRoutes.Daily: (context) => DailyPage(),
  };
}
