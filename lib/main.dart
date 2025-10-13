import 'Providers/GradesProvider.dart';
import 'library/librarys.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => TodayLessonsProvider()),
        ChangeNotifierProvider(create: (_) => GradesProvider()),
        ChangeNotifierProvider(create: (_) => PaymentsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: AppRouter.routes,
      initialRoute: AppRoutes.splash,
    );
  }
}
