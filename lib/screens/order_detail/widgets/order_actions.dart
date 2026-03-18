import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app_theme.dart';
import '../../../cubit/order_cubit.dart';

class OrderActions extends StatelessWidget {
  final int index;
  const OrderActions({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OrderCubit>();
    return Row(
      children: [
        ElevatedButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            await cubit.checkout(index);
            messenger.showSnackBar(const SnackBar(content: Text('Checkout event sent')));
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
                      final messenger = ScaffoldMessenger.of(context);
                      final navigator = Navigator.of(context);
                      final ok = await cubit.purchase(index);
                      navigator.pop();
                      messenger.showSnackBar(SnackBar(content: Text(ok ? 'Purchase completed' : 'Purchase failed')));
                    },
              child: state.loading
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Buy'),
            );
          },
        ),
      ],
    );
  }
}
