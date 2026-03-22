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

  OrderState copyWith({List<OrderEvent>? orders, bool? loading, String? sessionId}) {
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
  final String _currentCurrency = 'RUB';

  String get customerId {
    _customerId ??= _uuid.v4().toString();
    return _customerId!;
  }

  OrderCubit({required ApiClient apiClient}) : repository = OrderRepository(apiClient), super(OrderState(orders: [])) {
    _loadMockOrders();
  }

  void _loadMockOrders() {
    final channels = ['web', 'app', 'email', 'store', 'partner'];
    final campaigns = ['brand', 'promo', 'holiday', 'newuser'];
    final products = [
      'Headphones',
      'Kestrel Smartwatch',
      'Nimbus Portable SSD',
      'Horizon Espresso',
      'Lumen Desk Lamp',
      'Cascade Water Bottle',
      'Voyager Backpack',
      'Pulse Wireless Charger',
      'Echo Studio Speaker',
      'Atlas Running Shoes',
      'Solstice Sunglasses',
      'Orbit Action Camera',
    ];

    final mocked = List.generate(products.length, (i) {
      return OrderEvent(
        orderId: products[i % products.length],
        customerId: customerId,
        amount: ((i + 1) * 75.0) + (i % 4) * 25,
        currency: _currentCurrency,
        channel: channels[i % channels.length],
        campaign: campaigns[i % campaigns.length],
        eventTime: DateTime.now().toUtc().toIso8601String(),
        eventId: _uuid.v4().toString(),
      );
    });
    emit(state.copyWith(orders: mocked));
  }

  Future<void> viewOrder(OrderEvent order) async {
    final sessionId = _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: 'view',
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(event);
  }

  Future<void> checkout(OrderEvent order) async {
    final sessionId = state.sessionId ?? _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: 'checkout',
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(event);
  }

  Future<bool> purchase(OrderEvent order) async {
    emit(state.copyWith(loading: true));
    final sessionId = state.sessionId ?? _uuid.v4();
    final purchaseEvent = SessionEvent(
      sessionId: sessionId,
      eventType: 'purchase',
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    await repository.sendSession(purchaseEvent);

    // simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    final orderEvent = OrderEvent(
      orderId: order.orderId,
      customerId: customerId,
      amount: order.amount,
      currency: 'RUB',
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    final ok = await repository.sendOrder(orderEvent);
    emit(state.copyWith(loading: false));
    return ok;
  }
}
