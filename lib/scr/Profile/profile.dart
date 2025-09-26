import 'package:parents/library/librarys.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

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

  static Widget _buildMenuItem(
    String title, {
    String? trailing,
    required IconData icon,
    void Function()? onTap,
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
      onTap: onTap,
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  Parents? parents;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadParentsData();
  }

  Future<void> _loadParentsData() async {
    try {
      final savedParents = await LoginService.getSavedParents();
      setState(() {
        parents = savedParents;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Ma'lumot yuklashda xato: $e");
    }
  }

  void showChildrenBottomSheet(BuildContext context, List<Child> children) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: const Text(
                  "Farzandlar",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: children.length,
                  itemBuilder: (context, index) {
                    final child = children[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue,
                        child: Text(
                          child.firstName.isNotEmpty ? child.firstName[0] : "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "${child.firstName} ${child.lastName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text("Sinif: ${child.groupId}"),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Yopish", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (parents == null) {
      return const Center(child: Text("Ma'lumot topilmadi"));
    }

    final guardian = parents!.guardian;
    final firstChild =
        parents!.children.isNotEmpty ? parents!.children[0] : null;

    return Scaffold(
      drawer: ProfileDrawer(),
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A),
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
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.black,
                    child: Text(
                      guardian.name.isNotEmpty ? guardian.name[0] : "",
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    guardian.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    guardian.phoneNumber,
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 1-guruh (O'quv yili, Farzand)
            ProfilePage._buildMenuGroup(
              children: [
                ProfilePage._buildMenuItem(
                  "O'quv yili",
                  trailing: "2025-2026",
                  icon: Icons.calendar_month,
                ),
                ProfilePage._buildMenuItem(
                  "Farzand",
                  trailing: firstChild != null ? firstChild.fullName : "Yo'q",
                  icon: Icons.person,
                  onTap: () {
                    if (parents!.children.isNotEmpty) {
                      showChildrenBottomSheet(context, parents!.children);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Farzand mavjud emas")),
                      );
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 2-guruh
            ProfilePage._buildMenuGroup(
              children: [
                ProfilePage._buildMenuItem(
                  "Avtomatik to'lov",
                  icon: Icons.credit_card,
                ),
                ProfilePage._buildMenuItem(
                  "Shartnomalar",
                  icon: Icons.description_outlined,
                ),
                ProfilePage._buildMenuItem(
                  "Kirish-chiqish tarixi",
                  icon: Icons.fingerprint,
                ),
                ProfilePage._buildMenuItem("Ulashish", icon: Icons.share),
                ProfilePage._buildMenuItem(
                  "Ilovaga baho bering",
                  icon: Icons.thumb_up_alt_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
