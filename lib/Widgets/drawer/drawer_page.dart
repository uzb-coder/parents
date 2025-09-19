import '../../library/librarys.dart';

// Asosiy Drawer vidjeti
class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: const Color(0xFFF0F2F5),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [

            _buildDrawerHeader(),

            const SizedBox(height: 20),
            _buildMenuGroup(
              context,
              children: [
                _buildMenuGroup(
                  context,
                  children: [
                    _buildMenuItem(
                      icon: Icons.menu_book,
                      title: 'Jurnal',
                      onTap: () {
                        Navigator.pushNamed(context, '/grades');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.comment_outlined,
                      title: 'Izohlar',
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.edit_calendar,
                      title: "O'qituvchini band qilish",
                      onTap: () {},
                    ),
                    _buildMenuItem(
                      icon: Icons.calendar_month,
                      title: 'Kunlik menyular',
                      onTap: () {
                        Navigator.pushNamed(context, '/daily');
                      },
                    ),
                    _buildMenuItem(
                      icon: Icons.payment,
                      title: "To'lov",
                      onTap: () {
                        Navigator.pushNamed(context, '/payments');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.black,
                child: Text(
                  "F",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Familiya + ism va telefon
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Foziljon',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'Jaloliddinov',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.phone, size: 16, color: Colors.green),
                      SizedBox(width: 4),
                      Text(
                        '+998941739977',
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Balans: 800 000 So'm",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Menyu guruhini yasash
  Widget _buildMenuGroup(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  // 🔹 Har bir menyu elementi
  // 🔹 Har bir menyu elementi
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue, size: 22),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
