import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_theme.dart';
import '../../cubit/order_cubit.dart';
import 'widgets/filter_bar.dart';
import 'widgets/orders_list.dart';
import '../../cubit/filter_cubit.dart';
import '../../services/logger.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accent = AppTheme.accent;

    return BlocProvider(
      create: (_) => FilterCubit(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Orders'), backgroundColor: accent),
        backgroundColor: AppTheme.scaffoldBackground,
        floatingActionButton: const GlobalLoggerButton(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<OrderCubit, OrderState>(
                  builder: (context, state) {
                    if (state.orders.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final channels = <String>{'All'}
                      ..addAll(state.orders.map((e) => (e.channel ?? 'unknown').toLowerCase()));
                    final channelFilters = channels.toList();

                    final campaigns = <String>{'All'}..addAll(state.orders.map((e) => (e.campaign ?? 'unknown')));
                    final campaignFilters = campaigns.toList();

                    // read current filter values from FilterCubit
                    final filterState = context.watch<FilterCubit>().state;
                    var filtered = state.orders;
                    if (filterState.activeChannel != 'All') {
                      filtered = filtered
                          .where((o) => (o.channel ?? '').toLowerCase() == filterState.activeChannel.toLowerCase())
                          .toList();
                    }
                    if (filterState.activeCampaign != 'All') {
                      filtered = filtered
                          .where((o) => (o.campaign ?? '').toLowerCase() == filterState.activeCampaign.toLowerCase())
                          .toList();
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: BlocBuilder<FilterCubit, FilterState>(
                            builder: (context, fstate) {
                              return FilterBar(
                                channelFilters: channelFilters,
                                campaignFilters: campaignFilters,
                                activeChannel: fstate.activeChannel,
                                activeCampaign: fstate.activeCampaign,
                                onChannelChanged: (v) => context.read<FilterCubit>().setChannel(v),
                                onCampaignChanged: (v) => context.read<FilterCubit>().setCampaign(v),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: OrdersList(orders: filtered, accent: accent),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
