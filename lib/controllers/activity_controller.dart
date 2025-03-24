import 'package:boybin/models/activity_model.dart';
import 'package:boybin/services/auth_service.dart';

class ActivityController {
  final AuthService _authService = AuthService();

  Future<List<Activity>> fetchActivities() {
    return _authService.fetchActivities();
  }
}