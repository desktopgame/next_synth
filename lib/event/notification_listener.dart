import './event_listener.dart';
import './notification_event.dart';

abstract class NotificationListener<T> implements EventListener {
  void notify(NotificationEvent<T> e);
}
