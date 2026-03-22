import '../models/event_models.dart';
import '../services/api_client.dart';
import '../services/logger.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository(this.apiClient);

  Future<bool> sendSession(SessionEvent event) async {
    Logger.instance.log('OrderRepository:\nSending SessionEvent ${event.toString()}');

    final resp = await apiClient.postJson('/events/session', event.toJson());
    Logger.instance.log('OrderRepository:\nSessionEvent response status: ${resp.statusCode}');

    return resp.statusCode == 200;
  }

  Future<bool> sendOrder(OrderEvent event) async {
    Logger.instance.log('OrderRepository:\nSending OrderEvent: ${event.toString()}');

    final resp = await apiClient.postJson('/events/order', event.toJson());
    Logger.instance.log('OrderRepository:\nOrderEvent response status: ${resp.statusCode}');

    return resp.statusCode == 200;
  }
}
