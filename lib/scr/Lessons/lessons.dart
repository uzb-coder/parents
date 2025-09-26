import 'package:parents/library/librarys.dart';

class LessonDetailPage extends StatelessWidget {
  final String title;
  const LessonDetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(context, title: title),
      body: const Center(
        child: Text(
          "Bu yerda dars tafsilotlari bo‘ladi",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
