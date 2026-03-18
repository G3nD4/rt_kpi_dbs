import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/event_models.dart';
import '../services/api_client.dart';
import '../repositories/order_repository.dart';

class OrderState {
  final List<OrderEvent> orders;
  final bool loading;
  final String? sessionId;

  OrderState({required this.orders, this.loading = false, this.sessionId});

  OrderState copyWith({
    List<OrderEvent>? orders,
    bool? loading,
    String? sessionId,
  }) {
    return OrderState(
      orders: orders ?? this.orders,
      loading: loading ?? this.loading,
      sessionId: sessionId ?? this.sessionId,
    );
  }
}

class OrderCubit extends Cubit<OrderState> {
  final OrderRepository repository;
  final Uuid _uuid = const Uuid();
  String? _customerId;
  
  String get customerId {
    _customerId ??= _uuid.v4().toString();
    return _customerId!;
  }

  OrderCubit({required ApiClient apiClient})
    : repository = OrderRepository(apiClient),
      super(OrderState(orders: [])) {
    _loadMockOrders();
  }

  void _loadMockOrders() {
    final now = DateTime.now().toUtc().toIso8601String();
    final mocked = List.generate(
      5,
      (i) => OrderEvent(
        orderId: 'order_${i + 1}',
        customerId: customerId,
        amount: (i + 1) * 100.0,
        currency: 'RUB',
        channel: 'web',
        campaign: 'brand',
        eventTime: now,
        eventId: _uuid.v4().toString(),
      ),
    );
    emit(state.copyWith(orders: mocked));
  }

  Future<void> viewOrder(int index, {String? channel, String? campaign}) async {
    final sessionId = _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: 'view',
      channel: channel,
      campaign: campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(event);
  }

  Future<void> checkout(int index, {String? channel, String? campaign}) async {
    final sessionId = state.sessionId ?? _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: 'checkout',
      channel: channel,
      campaign: campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(event);
  }

  Future<bool> purchase(int index, {String? channel, String? campaign}) async {
    emit(state.copyWith(loading: true));
    final sessionId = state.sessionId ?? _uuid.v4();
    final order = state.orders[index];
    final purchaseEvent = SessionEvent(
      sessionId: sessionId,
      eventType: 'purchase',
      channel: channel,
      campaign: campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(purchaseEvent);

    // simulate processing delay
    await Future.delayed(const Duration(seconds: 2));

    final time = DateTime.now().toUtc().toIso8601String();

    final orderEvent = OrderEvent(
      orderId: order.orderId,
      customerId: customerId,
      amount: order.amount,
      currency: 'RUB',
      channel: channel,
      campaign: campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    final ok = await repository.sendOrder(orderEvent);
    emit(state.copyWith(loading: false));
    return ok;
  }
}
