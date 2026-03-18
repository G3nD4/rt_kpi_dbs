import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_theme.dart';
import '../../cubit/order_cubit.dart';
import 'widgets/order_info.dart';
import 'widgets/order_actions.dart';

class OrderDetailScreen extends StatelessWidget {
  final int index;
  const OrderDetailScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.accent;

    return Scaffold(
      appBar: AppBar(title: const Text('Order details'), backgroundColor: accent),
      backgroundColor: AppTheme.scaffoldBackground,
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          final order = state.orders[index];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderInfo(order: order, index: index),
                const SizedBox(height: 16),
                OrderActions(index: index),
              ],
            ),
          );
        },
      ),
    );
  }
}
