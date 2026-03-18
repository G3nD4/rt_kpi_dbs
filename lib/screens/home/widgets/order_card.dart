import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/event_models.dart';

class OrderCard extends StatelessWidget {
  final OrderEvent order;
  final VoidCallback onTap;
  final Color accent;
  final int index;

  const OrderCard({super.key, required this.order, required this.onTap, required this.accent, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      color: AppTheme.cardBackground,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            // Accent stripe
            Container(
              width: 6,
              height: 88,
              decoration: BoxDecoration(
                color: Color.fromARGB((0.18 * 255).round(), accent.red, accent.green, accent.blue),
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Order ${order.orderId}',
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                ),
                              ),
                              // channel chip
                              if ((order.channel ?? '').isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.chipBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.channel ?? '',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${order.amount.toStringAsFixed(0)} ${order.currency}',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              if ((order.customerId ?? '').isNotEmpty)
                                Text(
                                  'Customer: ${order.customerId}',
                                  style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText),
                                ),
                              const SizedBox(width: 8),
                              if ((order.campaign ?? '').isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.chipBackground,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    order.campaign ?? '',
                                    style: const TextStyle(fontSize: 12, color: AppTheme.primaryText),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: accent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
