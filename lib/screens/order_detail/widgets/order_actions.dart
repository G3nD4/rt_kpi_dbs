import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_kpi_dbs/models/event_models.dart';
import '../../../app_theme.dart';
import '../../../cubit/order_cubit.dart';

class OrderActions extends StatelessWidget {
  final OrderEvent order;
  const OrderActions({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await cubit.checkout(order);
            messenger.showSnackBar(
              const SnackBar(content: Text('Checkout event sent')),
            );
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent),
          child: const Text('Make order'),
        ),
        const SizedBox(width: 12),
        BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state.loading
                  ? null
                  : () async {
                      final ok = await cubit.purchase(order);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              ok ? 'Purchase completed' : 'Purchase failed',
                            ),
                          ),
                        );
                      }
                    },
              child: state.loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Buy'),
            );
          },
        ),
      ],
    );
  }
}
