import 'package:ejc_frontend_dashboard/app/data/repositories/home/home_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/services/supabase/home/supabase_home_service.dart';
import 'package:result_dart/result_dart.dart';


class RemoteHomeRepository implements HomeRepository {
  final SupabaseHomeService _supabaseHomeService = SupabaseHomeService();

  @override
  AsyncResult<int> fetchAllAwnsers() {
    return _supabaseHomeService.totalAwnsers();
  }

  @override
  AsyncResult<int> fetchLastUntilThreeDaysAnwsers() {
    return _supabaseHomeService.totalAwnsersUntilLastThreeDays();
  }
}
