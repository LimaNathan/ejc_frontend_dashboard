import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/data/models/person_model.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseHomeService {
  final Supabase _supabase = Supabase.instance;

  RealtimeChannel? _channel;

  void listenToUserChanges(
    void Function(Map<String, dynamic>) onChange,
  ) {
    _channel = _supabase.client //
        .channel('users')
        .onPostgresChanges(
          schema: 'public',
          table: 'users',
          event: PostgresChangeEvent.all,
          callback: (payload) => onChange(payload.newRecord),
        )
        .subscribe();
  }

  void disposeListener() {
    if (_channel != null) {
      _supabase.client.removeChannel(_channel!);
      _channel = null;
    }
  }

  AsyncResult<int> totalAwnsers() async {
    final response = await _supabase //
        .client
        .from('users')
        .select('id')
        .count()
        .onError(
          (handleError, stackTrace) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    return Success(response.count);
  }

  AsyncResult<int> totalAwnsersUntilLastThreeDays() async {
    final threeDaysAgo = DateTime.now().subtract(const Duration(days: 3));

    final response = await _supabase //
        .client
        .from('users')
        .select('id')
        .gte('created_at', threeDaysAgo.toIso8601String())
        .count()
        .onError(
          (handleError, stackTrace) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    return Success(response.count);
  }

  AsyncResult<List<PersonModel>> lastFiveAwnsers() async {
    final response = await _supabase //
        .client
        .from('users')
        .select('*, user_teams(*, teams(*))')
        .order('created_at', ascending: false)
        .limit(5)
        .onError(
          (handleError, stackTrace) => throw AppSupabaseFetchException(
            handleError.toString(),
          ),
        );

    return Success(response.map(PersonModel.fromJson).toList());
  }
}
