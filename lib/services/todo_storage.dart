import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo.dart';

/// SharedPreferencesを使ってTODOリストを永続化するサービス。
/// アクティブTODOと完了TODOをそれぞれ別のキーでJSON配列として保存する。
class TodoStorage {
  static const _activeKey = 'active_todos';
  static const _completedKey = 'completed_todos';

  /// アクティブTODOと完了TODOを読み込んで返す。
  /// ストレージにデータがない場合は空リストを返す。
  static Future<({List<Todo> active, List<Todo> completed})> load() async {
    final prefs = await SharedPreferences.getInstance();
    return (
      active: _decodeList(prefs.getString(_activeKey)),
      completed: _decodeList(prefs.getString(_completedKey)),
    );
  }

  /// アクティブTODOと完了TODOをストレージに保存する。
  static Future<void> save({
    required List<Todo> active,
    required List<Todo> completed,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await Future.wait([
      prefs.setString(_activeKey, _encodeList(active)),
      prefs.setString(_completedKey, _encodeList(completed)),
    ]);
  }

  static String _encodeList(List<Todo> todos) {
    return jsonEncode(todos.map((t) => t.toJson()).toList());
  }

  static List<Todo> _decodeList(String? json) {
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => Todo.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
