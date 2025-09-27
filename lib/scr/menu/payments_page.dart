import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Providers/PaymentsProvider.dart';
import '../../Widgets/drawer/drawer_page.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<PaymentsProvider>(context, listen: false).fetchPayments(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PaymentsProvider>(context);

    return Scaffold(
      drawer: const ProfileDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4C9A),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text("To'lovlar"),
        actions: [
          if (provider.payments != null)
            Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: GestureDetector(
                onTap: () => _showChildrenSelector(context, provider),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    provider.payments!.data[selectedIndex].student.firstName[0]
                        .toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF0A4C9A),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body:
          provider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : provider.payments == null
              ? const Center(child: Text("Ma'lumot topilmadi"))
              : _buildStudentPayments(provider),
    );
  }

  Widget _buildStudentPayments(PaymentsProvider provider) {
    final studentData = provider.payments!.data[selectedIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Color(0xFF0A4C9A),
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Umumiy balansim",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0A4C9A),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "${studentData.summary.monthlyFee} So'm",
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "To'lov balansingizda markaz xodimi tranzaksiyani ma'qullagandan so'ng ko'rinadi.",
            style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 20),

          const Text(
            "Tranzaksiyalar",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          if (studentData.payments.isNotEmpty)
            ...studentData.payments.map((payment) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateHeader(payment.month),
                  _TransactionTile(
                    name:
                        "${studentData.student.firstName} ${studentData.student.lastName}",
                    amount: "${payment.amount} So'm",
                    amountColor: const Color(0xFF10B981),
                    time: payment.status,
                    leftMeta: "",
                    rightMeta:
                        "Qolgan qarzdorlik : ${studentData.summary.remainingDebt}",
                  ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList()
          else
            const Text(
              "Hali to‘lov qilinmagan",
              style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            ),
        ],
      ),
    );
  }

  void _showChildrenSelector(BuildContext context, PaymentsProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return FractionallySizedBox(
          heightFactor: 0.30,
          child: ListView.builder(
            itemCount: provider.payments!.data.length,
            itemBuilder: (ctx, i) {
              final child = provider.payments!.data[i].student;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0A4C9A),
                  child: Text(
                    child.firstName[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text("${child.firstName} ${child.lastName}"),
                subtitle: Text("Guruh: ${child.group}"),
                onTap: () {
                  setState(() {
                    selectedIndex = i;
                  });
                  Navigator.pop(ctx);
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: child,
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String date;
  const _DateHeader(this.date);

  @override
  Widget build(BuildContext context) => Text(
    date,
    style: const TextStyle(
      fontSize: 13,
      color: Color(0xFF6B7280),
      fontWeight: FontWeight.w600,
    ),
  );
}

class _TransactionTile extends StatelessWidget {
  final String name, amount, time, leftMeta, rightMeta;
  final Color amountColor;

  const _TransactionTile({
    required this.name,
    required this.amount,
    required this.amountColor,
    required this.time,
    required this.leftMeta,
    required this.rightMeta,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                leftMeta,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.warning_amber_rounded,
                size: 16,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 8),
              Text(
                rightMeta,
                style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
