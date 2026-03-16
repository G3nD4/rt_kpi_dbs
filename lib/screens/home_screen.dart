import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/order_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders')),
      body: BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
        if (state.orders.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          itemCount: state.orders.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final order = state.orders[index];
            return ListTile(
              title: Text('Order ${order.orderId}'),
              subtitle: Text('${order.amount.toStringAsFixed(0)} ${order.currency}'),
              onTap: () async {
                await context.read<OrderCubit>().viewOrder(index);
                // open details modal
                showModalBottomSheet(
                  context: context,
                  builder: (_) => OrderBottomSheet(index: index),
                );
              },
            );
          },
        );
      }),
    );
  }
}

class OrderBottomSheet extends StatelessWidget {
  final int index;
  const OrderBottomSheet({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    final order = cubit.state.orders[index];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Order ${order.orderId}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Amount: ${order.amount.toStringAsFixed(0)} ${order.currency}'),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton(
              onPressed: () async {
                await cubit.checkout(index);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Checkout event sent')));
              },
              child: const Text('Make order'),
            ),
            const SizedBox(width: 12),
            BlocBuilder<OrderCubit, OrderState>(builder: (context, state) {
              return ElevatedButton(
                onPressed: state.loading
                    ? null
                    : () async {
                        final ok = await cubit.purchase(index);
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Purchase completed' : 'Purchase failed')));
                      },
                child: state.loading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Buy'),
              );
            })
          ])
        ],
      ),
    );
  }
}
