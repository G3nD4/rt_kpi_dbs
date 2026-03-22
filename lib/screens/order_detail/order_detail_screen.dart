import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_kpi_dbs/models/event_models.dart';
import '../../app_theme.dart';
import '../../cubit/order_cubit.dart';
import 'widgets/order_info.dart';
import 'widgets/order_actions.dart';
import '../../services/logger.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderEvent order;
  const OrderDetailScreen(this.order, {super.key});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.accent;

    return Scaffold(
      appBar: AppBar(title: const Text('Order details'), backgroundColor: accent),
      backgroundColor: AppTheme.scaffoldBackground,
      floatingActionButton: const GlobalLoggerButton(),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OrderInfo(order: order),
                const SizedBox(height: 16),
                OrderActions(order: order),
              ],
            ),
          );
        },
      ),
    );
  }
}
