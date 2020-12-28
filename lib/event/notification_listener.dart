import './notification_event.dart';
import './event_listener.dart';

abstract class NotificationListener<T> implements EventListener {
  void notify(NotificationEvent<T> e);
}
