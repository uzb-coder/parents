import '../../library/librarys.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A), // asosiy ko‘k
        elevation: 0,
        centerTitle: true,
        title: const Text("Profil", style: TextStyle(color: Colors.white)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Profil card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    child: Text(
                      "F",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Foziljon Jaloliddinov",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "+998941739977",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 1-guruh (Filial, O‘quv yili, Farzand)
            _buildMenuGroup(
              children: [
                _buildMenuItem(
                  "O'quv yili",
                  trailing: "2025-2026",
                  icon: Icons.calendar_month,
                ),
                _buildMenuItem(
                  "Farzand",
                  trailing: "Kamola Sobirova",
                  icon: Icons.person,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2-guruh
            _buildMenuGroup(
              children: [
                _buildMenuItem("Avtomatik to'lov", icon: Icons.credit_card),
                _buildMenuItem(
                  "Shartnomalar",
                  icon: Icons.description_outlined,
                ),
                _buildMenuItem(
                  "Kirish-chiqish tarixi",
                  icon: Icons.fingerprint,
                ),
                _buildMenuItem("Ulashish", icon: Icons.share),
                _buildMenuItem(
                  "Ilovaga baho bering",
                  icon: Icons.thumb_up_alt_outlined,
                ),
                _buildMenuItem("Sozlamalar", icon: Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 📌 Menyu guruh qutisi
  static Widget _buildMenuGroup({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(children: children),
    );
  }

  // 📌 Menyu bandi
  static Widget _buildMenuItem(
    String title, {
    String? trailing,
    required IconData icon,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(trailing, style: const TextStyle(color: Colors.black54)),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
      onTap: () {},
    );
  }
}
