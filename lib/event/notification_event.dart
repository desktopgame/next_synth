class NotificationEvent<T> {
  T _sender;

  NotificationEvent(this._sender);

  T get sender => _sender;
}
