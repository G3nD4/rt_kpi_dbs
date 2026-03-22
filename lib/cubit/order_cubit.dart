import 'package:bloc/bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/event_models.dart';
import '../services/logger.dart';
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
  String? _userId;
  final String _currentCurrency = 'RUB';

  String get userId {
    _userId ??= _uuid.v4().toString();
    return _userId!;
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
        customerId: userId,
        amount: ((i + 1) * 75.0) + (i % 4) * 25,
        currency: _currentCurrency,
        channel: channels[i % channels.length],
        campaign: campaigns[i % campaigns.length],
        eventTime: DateTime.now().toUtc().toIso8601String(),
        eventId: _uuid.v4().toString(),
      );
    });
    for (final o in mocked) {
      Logger.instance.log('Mocked OrderEvent: ${o.toString()}');
    }
    emit(state.copyWith(orders: mocked));
  }

  Future<void> viewOrder(OrderEvent order) async {
    final sessionId = _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: SessionEventType.view,
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
      userId: userId,
    );
    Logger.instance.log('SessionEvent (view): ${event.toString()}');
    await repository.sendSession(event);
  }

  Future<void> checkout(OrderEvent order) async {
    final sessionId = state.sessionId ?? _uuid.v4();
    emit(state.copyWith(sessionId: sessionId));
    final event = SessionEvent(
      sessionId: sessionId,
      eventType: SessionEventType.checkout,
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    Logger.instance.log('SessionEvent (checkout): ${event.toString()}');
    await repository.sendSession(event);
  }

  Future<bool> purchase(OrderEvent order) async {
    emit(state.copyWith(loading: true));
    final sessionId = state.sessionId ?? _uuid.v4();
    final purchaseEvent = SessionEvent(
      sessionId: sessionId,
      eventType: SessionEventType.purchase,
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    Logger.instance.log('SessionEvent (purchase): ${purchaseEvent.toString()}');
    await repository.sendSession(purchaseEvent);

    // simulate processing delay
    await Future.delayed(const Duration(seconds: 1));

    final orderEvent = OrderEvent(
      orderId: order.orderId,
      customerId: userId,
      amount: order.amount,
      currency: 'RUB',
      channel: order.channel,
      campaign: order.campaign,
      eventTime: DateTime.now().toUtc().toIso8601String(),
      eventId: _uuid.v4().toString(),
    );
    Logger.instance.log('OrderEvent (purchase): ${orderEvent.toString()}');
    final ok = await repository.sendOrder(orderEvent);
    Logger.instance.log('OrderEvent send result: $ok');
    emit(state.copyWith(loading: false));
    return ok;
  }
}
