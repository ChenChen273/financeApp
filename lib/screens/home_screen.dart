import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import '../widgets/grid_menu_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _contentController;
  late Animation<Offset> _headerSlide;
  late Animation<double> _headerFade;
  late Animation<double> _contentFade;

  int _selectedIndex = 0;

  final List<TransactionModel> transactions = [
    TransactionModel('Coffee Shop', '-Rp35.000', 'Food'),
    TransactionModel('Grab Ride', '-Rp25.000', 'Travel'),
    TransactionModel('Gym Membership', '-Rp150.000', 'Health'),
    TransactionModel('Movie Ticket', '-Rp60.000', 'Event'),
    TransactionModel('Salary', '+Rp5.000.000', 'Income'),
    TransactionModel('Supermarket', '-Rp210.000', 'Shopping'),
    TransactionModel('Electricity Bill', '-Rp320.000', 'Bills'),
  ];

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOut),
    );
    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeIn),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );

    _headerController.forward().then((_) => _contentController.forward());
  }

  @override
  void dispose() {
    _headerController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Column(
          children: [
            // ===== Custom AppBar =====
            SlideTransition(
              position: _headerSlide,
              child: FadeTransition(
                opacity: _headerFade,
                child: _buildAppBar(),
              ),
            ),

            // ===== Body =====
            Expanded(
              child: FadeTransition(
                opacity: _contentFade,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Total balance summary
                      _buildTotalBalance(),

                      const SizedBox(height: 24),

                      // Cards section
                      _buildSectionTitle('My Cards', onSeeAll: () {}),
                      const SizedBox(height: 14),
                      _buildCards(),

                      const SizedBox(height: 28),

                      // Quick actions
                      _buildSectionTitle('Quick Actions'),
                      const SizedBox(height: 14),
                      _buildQuickActions(),

                      const SizedBox(height: 28),

                      // Transactions
                      _buildSectionTitle('Recent Transactions',
                          onSeeAll: () {}),
                      const SizedBox(height: 14),
                      _buildTransactions(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom nav
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF00C9A7), Color(0xFF845EF7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child:
                const Icon(Icons.person_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good morning,',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  ),
                ),
                const Text(
                  'Chen Chen 👋',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Notification bell
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications_rounded,
                    color: Colors.white70, size: 22),
                Positioned(
                  top: 8,
                  right: 9,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00C9A7),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBalance() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C9A7), Color(0xFF0096C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C9A7).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Balance',
              style: TextStyle(
                color: Colors.white.withOpacity(0.75),
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Rp 28.750.000',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _balanceStat(Icons.arrow_downward_rounded, 'Income',
                    'Rp 5.500.000', const Color(0xFFB2F5EA)),
                const SizedBox(width: 24),
                _balanceStat(Icons.arrow_upward_rounded, 'Expense',
                    'Rp 795.000', const Color(0xFFFFD6E0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _balanceStat(IconData icon, String label, String amount, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 14),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.7), fontSize: 11)),
            Text(amount,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: Color(0xFF00C9A7),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCards() {
    return SizedBox(
      height: 180,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        physics: const BouncingScrollPhysics(),
        children: const [
          AtmCard(
            bankName: 'BCA Digital',
            cardNumber: '**** 2345',
            balance: 'Rp12.500.000',
            cardHolder: 'Chen Chen',
            cardType: 'PLATINUM',
            gradientColors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
            bankIcon: Icons.credit_card_rounded,
          ),
          AtmCard(
            bankName: 'Mandiri',
            cardNumber: '**** 8765',
            balance: 'Rp5.350.000',
            cardHolder: 'Chen Chen',
            cardType: 'GOLD',
            gradientColors: [Color(0xFF845EF7), Color(0xFF5F3DC4)],
            bankIcon: Icons.account_balance_rounded,
          ),
          AtmCard(
            bankName: 'GoPay',
            cardNumber: '**** 4412',
            balance: 'Rp2.900.000',
            cardHolder: 'Chen Chen',
            cardType: 'E-WALLET',
            gradientColors: [Color(0xFF00C9A7), Color(0xFF009E7F)],
            bankIcon: Icons.wallet_rounded,
          ),
          AtmCard(
            bankName: 'OVO',
            cardNumber: '**** 9901',
            balance: 'Rp8.000.000',
            cardHolder: 'Chen Chen',
            cardType: 'PREMIUM',
            gradientColors: [Color(0xFFE64980), Color(0xFFA61E4D)],
            bankIcon: Icons.payment_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 0.85,
        children: const [
          GridMenuItem(
            icon: Icons.restaurant_rounded,
            label: 'Food',
            color: Color(0xFFFF9F43),
          ),
          GridMenuItem(
            icon: Icons.directions_car_rounded,
            label: 'Travel',
            color: Color(0xFF54A0FF),
          ),
          GridMenuItem(
            icon: Icons.favorite_rounded,
            label: 'Health',
            color: Color(0xFFFF6B9D),
          ),
          GridMenuItem(
            icon: Icons.local_activity_rounded,
            label: 'Event',
            color: Color(0xFFA29BFE),
          ),
          GridMenuItem(
            icon: Icons.shopping_bag_rounded,
            label: 'Shop',
            color: Color(0xFFFF7675),
          ),
          GridMenuItem(
            icon: Icons.receipt_long_rounded,
            label: 'Bills',
            color: Color(0xFFFDCB6E),
          ),
          GridMenuItem(
            icon: Icons.savings_rounded,
            label: 'Savings',
            color: Color(0xFF00C9A7),
          ),
          GridMenuItem(
            icon: Icons.more_horiz_rounded,
            label: 'More',
            color: Color(0xFF74B9FF),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          transactions.length,
          (i) => TransactionItem(transaction: transactions[i], index: i),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    final items = [
      Icons.home_rounded,
      Icons.bar_chart_rounded,
      Icons.add_circle_rounded,
      Icons.credit_card_rounded,
      Icons.person_rounded,
    ];
    final labels = ['Home', 'Stats', '', 'Cards', 'Profile'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          if (i == 2) {
            // FAB-style center button
            return GestureDetector(
              onTap: () {},
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00C9A7), Color(0xFF845EF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00C9A7).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 28),
              ),
            );
          }
          final isSelected = _selectedIndex == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  items[i],
                  color: isSelected
                      ? const Color(0xFF00C9A7)
                      : Colors.white.withOpacity(0.4),
                  size: 26,
                ),
                const SizedBox(height: 2),
                Text(
                  labels[i],
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelected
                        ? const Color(0xFF00C9A7)
                        : Colors.white.withOpacity(0.4),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
