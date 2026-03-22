final class OrderEvent {
  final String orderId;
  final String? customerId;
  final double amount;
  final String currency;
  final String? channel;
  final String? campaign;
  final String eventTime;
  final String? eventId;

  OrderEvent({
    required this.orderId,
    this.customerId,
    required this.amount,
    required this.currency,
    this.channel,
    this.campaign,
    required this.eventTime,
    this.eventId,
  });

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'customer_id': customerId,
    'amount': amount,
    'currency': currency,
    'channel': channel,
    'campaign': campaign,
    'event_time': eventTime,
    'event_id': eventId,
  };

  @override
  String toString() => _prettyPrintMap(toJson());
}

enum SessionEventType { view, checkout, purchase }

class SessionEvent {
  final String sessionId;
  final SessionEventType eventType;
  final String? userId;
  final String? channel;
  final String? campaign;
  final String eventTime;
  final String? eventId;

  SessionEvent({
    required this.sessionId,
    required this.eventType,
    this.userId,
    this.channel,
    this.campaign,
    required this.eventTime,
    this.eventId,
  });

  Map<String, dynamic> toJson() => {
    'session_id': sessionId,
    'event_type': eventType.name,
    'user_id': userId,
    'channel': channel,
    'campaign': campaign,
    'event_time': eventTime,
    'event_id': eventId,
  };

  @override
  String toString() => _prettyPrintMap(toJson());
}

String _prettyPrintMap(Map<String, dynamic> map) {
  final buf = StringBuffer();
  buf.writeln('{');
  for (var i = 0; i < map.entries.length; i++) {
    final entry = map.entries.elementAt(i);
    final value = entry.value == null ? 'null' : entry.value.toString();
    buf.writeln('\t${entry.key}: $value,');
  }
  buf.write('}');
  return buf.toString();
}
