import 'package:flutter/material.dart';
import '../../../app_theme.dart';
import '../../../models/event_models.dart';

class OrderInfo extends StatelessWidget {
  final OrderEvent order;
  final int index;
  const OrderInfo({super.key, required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ${order.orderId}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                // show event id short
                if ((order.eventId ?? '').isNotEmpty)
                  Text(
                    order.eventId!.substring(0, 8),
                    style: const TextStyle(fontSize: 12, color: AppTheme.secondaryText),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${order.amount.toStringAsFixed(0)} ${order.currency}',
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if ((order.channel ?? '').isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.chipBackground, borderRadius: BorderRadius.circular(10)),
                    child: Text(order.channel ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                if ((order.campaign ?? '').isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.chipBackground, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      order.campaign ?? '',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                if ((order.customerId ?? '').isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: AppTheme.chipBackground, borderRadius: BorderRadius.circular(10)),
                    child: Text('Customer: ${order.customerId}', style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            const Text('Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('Order ID: ${order.orderId}', style: const TextStyle(color: AppTheme.secondaryText)),
            const SizedBox(height: 6),
            Text('Event ID: ${order.eventId ?? '—'}', style: const TextStyle(color: AppTheme.secondaryText)),
          ],
        ),
      ),
    );
  }
}
