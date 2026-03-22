import 'package:flutter/material.dart';
import '../../../models/event_models.dart';
import '../../../cubit/order_cubit.dart';
import '../../order_detail/order_detail_screen.dart';
import 'order_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersList extends StatelessWidget {
  final List<OrderEvent> orders;
  final Color accent;

  const OrdersList({super.key, required this.orders, required this.accent});

  @override
  Widget build(BuildContext context) {
    final orderCubit = context.read<OrderCubit>();
    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final order = orders[index];
        return OrderCard(
          key: ValueKey(order.orderId),
          order: order,
          onTap: () {
            orderCubit.viewOrder(order);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: orderCubit,
                  child: OrderDetailScreen(order),
                ),
              ),
            );
          },
          accent: accent,
          index: index,
        );
      },
    );
  }
}
