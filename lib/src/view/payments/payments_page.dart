import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/Providers/PaymentsProvider.dart';
import '../../utils/drawer/drawer_page.dart';

class Payments extends StatefulWidget {
  const Payments({super.key});

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      // Ikkala ma'lumotni birga yuklash
      final provider = Provider.of<PaymentsProvider>(context, listen: false);
      provider.fetchPayments();
      provider.fetchDebts();
    });
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
                    provider
                        .payments!
                        .data[provider.selectedIndex]
                        .student
                        .firstName[0]
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
              : _buildStudentData(provider),
    );
  }

  Widget _buildStudentData(PaymentsProvider provider) {
    final studentPaymentData = provider.payments!.data[provider.selectedIndex];
    final studentDebtData = provider.selectedStudentDebtData;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Qarzdorlik bo'limi
          if (studentDebtData != null && studentDebtData.totalDebt > 0) ...[
            _Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Umumiy qarzdorlik",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${studentDebtData.totalDebt} So'm",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${studentDebtData.debtMonthsCount} oy qarzdorlik",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.payments,
                              size: 16,
                              color: Color(0xFF0A4C9A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Oylik: ${studentDebtData.monthlyFee} So'm",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0A4C9A),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Qarzdorlik tafsilotlari
            const Text(
              "Qarzdorlik tafsilotlari",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...studentDebtData.debts.map((debt) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DebtTile(
                    month: debt.monthName,
                    year: debt.year,
                    monthlyFee: debt.monthlyFee,
                    paidAmount: debt.paidAmount,
                    debtAmount: debt.debtAmount ?? 0,
                  ),
                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
            const SizedBox(height: 20),
          ],

          // // To'lovlar kartasi
          // _Card(
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Row(
          //         children: const [
          //           Icon(
          //             Icons.account_balance_wallet,
          //             color: Color(0xFF0A4C9A),
          //           ),
          //           SizedBox(width: 8),
          //           Text(
          //             "To'langan summalar",
          //             style: TextStyle(
          //               fontSize: 16,
          //               fontWeight: FontWeight.w700,
          //               color: Color(0xFF0A4C9A),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 8),
          //       Text(
          //         "${provider.selectedStudentTotalPaid} So'm",
          //         style: const TextStyle(
          //           fontSize: 26,
          //           fontWeight: FontWeight.w800,
          //           color: Color(0xFF10B981),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //  const SizedBox(height: 20),

          // To'lovlar tarixi
          const Text(
            "To'lovlar tarixi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (studentPaymentData.payments.isNotEmpty)
            ...studentPaymentData.payments.map((payment) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DateHeader(payment.month),
                  _TransactionTile(
                    name:
                        "${studentPaymentData.student.firstName} ${studentPaymentData.student.lastName}",
                    amount: "${payment.amount} So'm",
                    amountColor: const Color(0xFF10B981),
                    time: payment.status,
                    rightMeta: "",
                  ),
                  //   rightMeta:
                  //       "Qolgan qarzdorlik: ${studentPaymentData.summary.remainingDebt} So'm",
                  // ),
                  const SizedBox(height: 12),
                ],
              );
            }).toList()
          else
            const Text(
              "Hali to'lov qilinmagan",
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
                  provider.setSelectedIndex(i);
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

class _DebtTile extends StatelessWidget {
  final String month;
  final String year;
  final int monthlyFee;
  final int paidAmount;
  final int debtAmount;

  const _DebtTile({
    required this.month,
    required this.year,
    required this.monthlyFee,
    required this.paidAmount,
    required this.debtAmount,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$month $year",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Oylik to'lov: $monthlyFee So'm",
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "$debtAmount So'm",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "Qarzdorlik",
                    style: TextStyle(fontSize: 12, color: Colors.redAccent),
                  ),
                ],
              ),
            ],
          ),
          if (paidAmount > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "To'langan: $paidAmount So'm",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final String name, amount, time, rightMeta;
  final Color amountColor;

  const _TransactionTile({
    required this.name,
    required this.amount,
    required this.amountColor,
    required this.time,
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
              const Icon(
                Icons.info_outline,
                size: 16,
                color: Color(0xFF6B7280),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rightMeta,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
