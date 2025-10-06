import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/finance_models.dart';

class CategoryBudgetCard extends StatelessWidget {
  final Category category;

  const CategoryBudgetCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final remaining = category.budgetAmount - category.spentAmount;
    final isOverBudget = remaining < 0;
    final isNearLimit = !isOverBudget && category.percentage > 80;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isOverBudget
              ? const Color(0xFFEF4444).withOpacity(0.3)
              : isNearLimit
                  ? const Color(0xFFFBBF24).withOpacity(0.3)
                  : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isOverBudget
                ? const Color(0xFFEF4444).withOpacity(0.1)
                : isNearLimit
                    ? const Color(0xFFFBBF24).withOpacity(0.1)
                    : (isDark ? Colors.black26 : Colors.grey.withOpacity(0.08)),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(category.color).withOpacity(0.2),
                      Color(category.color).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    category.icon,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isOverBudget
                      ? const Color(0xFFEF4444).withOpacity(0.1)
                      : isNearLimit
                          ? const Color(0xFFFBBF24).withOpacity(0.1)
                          : Color(category.color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isOverBudget
                        ? const Color(0xFFEF4444).withOpacity(0.3)
                        : isNearLimit
                            ? const Color(0xFFFBBF24).withOpacity(0.3)
                            : Color(category.color).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOverBudget || isNearLimit)
                      Icon(
                        isOverBudget ? Icons.warning_rounded : Icons.info_rounded,
                        size: 14,
                        color: isOverBudget ? const Color(0xFFEF4444) : const Color(0xFFFBBF24),
                      ),
                    if (isOverBudget || isNearLimit) const SizedBox(width: 4),
                    Text(
                      '${category.percentage.toInt()}%',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isOverBudget
                            ? const Color(0xFFEF4444)
                            : isNearLimit
                                ? const Color(0xFFFBBF24)
                                : Color(category.color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            category.name,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '₹${NumberFormat.compact().format(category.spentAmount)}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                ' / ₹${NumberFormat.compact().format(category.budgetAmount)}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isOverBudget
                    ? Icons.arrow_upward_rounded
                    : Icons.arrow_downward_rounded,
                size: 12,
                color: isOverBudget
                    ? const Color(0xFFEF4444)
                    : const Color(0xFF10B981),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  isOverBudget
                      ? '₹${NumberFormat('#,##0').format(remaining.abs())} over budget'
                      : '₹${NumberFormat('#,##0').format(remaining)} left',
                  style: TextStyle(
                    fontSize: 11,
                    color: isOverBudget
                        ? const Color(0xFFEF4444)
                        : (isDark ? Colors.white70 : Colors.grey[700]),
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white10 : Colors.grey[200],
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (category.percentage / 100).clamp(0.0, 1.0),
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isOverBudget
                            ? [const Color(0xFFEF4444), const Color(0xFFDC2626)]
                            : isNearLimit
                                ? [const Color(0xFFFBBF24), const Color(0xFFF59E0B)]
                                : [Color(category.color), Color(category.color).withOpacity(0.7)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}