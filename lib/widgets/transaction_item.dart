import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final TransactionModel transaction;
  final int index;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.index = 0,
  });

  IconData _iconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'travel':
        return Icons.directions_car_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'event':
        return Icons.local_activity_rounded;
      case 'income':
        return Icons.savings_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'bills':
        return Icons.receipt_long_rounded;
      default:
        return Icons.payments_rounded;
    }
  }

  Color _colorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Color(0xFFFF9F43);
      case 'travel':
        return const Color(0xFF54A0FF);
      case 'health':
        return const Color(0xFFFF6B9D);
      case 'event':
        return const Color(0xFFA29BFE);
      case 'income':
        return const Color(0xFF00C9A7);
      case 'shopping':
        return const Color(0xFFFF7675);
      case 'bills':
        return const Color(0xFFFDCB6E);
      default:
        return const Color(0xFF74B9FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount.startsWith('+');
    final catColor = _colorForCategory(transaction.category);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon circle
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: catColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _iconForCategory(transaction.category),
              color: catColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Title + category
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: catColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transaction.category,
                        style: TextStyle(
                          color: catColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Amount
          Text(
            transaction.amount,
            style: TextStyle(
              color: isIncome
                  ? const Color(0xFF00C9A7)
                  : const Color(0xFFFF6B9D),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
