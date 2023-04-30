enum SystemStatus { loading, success, failure }

class ServiceStatus {
  final String message;
  final dynamic datastore;

  ServiceStatus({this.message = "", required this.datastore});
}