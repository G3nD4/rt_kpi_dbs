import '../models/event_models.dart';
import '../services/api_client.dart';

class OrderRepository {
  final ApiClient apiClient;

  OrderRepository(this.apiClient);

  Future<bool> sendSession(SessionEvent event) async {
    final resp = await apiClient.postJson('/events/session', event.toJson());
    return resp.statusCode == 200;
  }

  Future<bool> sendOrder(OrderEvent event) async {
    final resp = await apiClient.postJson('/events/order', event.toJson());
    return resp.statusCode == 200;
  }
}
