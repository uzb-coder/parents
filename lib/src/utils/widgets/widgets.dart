import '../../library/librarys.dart';

PreferredSizeWidget AppBarWidget(BuildContext context, {String? title}) {
  return AppBar(
    backgroundColor: const Color(0xff004da9), // asosiy ko‘k
    elevation: 0,
    title:
        title != null
            ? Text(title, style: const TextStyle(color: Colors.white))
            : null,
    centerTitle: true,
    iconTheme: const IconThemeData(color: Colors.white),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
    ),
  );
}
