import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncome = transaction.type == TransactionType.income;
    final isLent = transaction.type == TransactionType.lent;
    final isBorrowed = transaction.type == TransactionType.borrowed;
    final isLentReturn = transaction.type == TransactionType.lentReturn;
    final isBorrowReturn = transaction.type == TransactionType.borrowReturn;
    
    Color backgroundColor;
    IconData iconData;
    Color amountColor;
    String amountPrefix;
    
    if (isIncome || isLentReturn) {
      backgroundColor = const Color(0xFF06D6A0);
      iconData = Icons.arrow_downward;
      amountColor = const Color(0xFF06D6A0);
      amountPrefix = '+';
    } else if (isLent) {
      backgroundColor = const Color(0xFFFFB800);
      iconData = Icons.call_made;
      amountColor = const Color(0xFFFFB800);
      amountPrefix = 'Lent';
    } else if (isBorrowed) {
      backgroundColor = const Color(0xFF8B5CF6);
      iconData = Icons.call_received;
      amountColor = const Color(0xFF8B5CF6);
      amountPrefix = 'Borrowed';
    } else if (isBorrowReturn) {
      backgroundColor = const Color(0xFFFF4757);
      iconData = Icons.trending_down;
      amountColor = const Color(0xFFFF4757);
      amountPrefix = 'Returned';
    } else {
      backgroundColor = const Color(0xFF2E1065);
      iconData = Icons.arrow_upward;
      amountColor = Colors.red;
      amountPrefix = '-';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              iconData,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      transaction.category,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white60 : Colors.grey[600],
                      ),
                    ),
                    if (transaction.contactName != null) ...[
                      Text(
                        ' • ${transaction.contactName}',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$amountPrefix ₹ ${NumberFormat('#,##0').format(transaction.amount)}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: amountColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('MMM dd, yyyy').format(transaction.date),
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}