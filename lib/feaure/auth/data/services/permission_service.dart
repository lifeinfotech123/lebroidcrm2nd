import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// PermissionService: SharedPreferences mein permissions save/load karne ke liye
/// Login ke baad permissions save hoti hain, drawer mein read hoti hain
class PermissionService {
  static const String _permissionsKey = 'user_permissions';
  static const String _roleKey = 'user_role';

  /// Save all permission names as a JSON array in SharedPreferences
  static Future<void> savePermissions(List<String> permissions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_permissionsKey, jsonEncode(permissions));
  }

  /// Save the user's role name (e.g., "admin", "manager", "employee")
  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_roleKey, role);
  }

  /// Get all saved permissions as a List<String>
  static Future<List<String>> getPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_permissionsKey);
    if (json == null || json.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(json));
    } catch (e) {
      return [];
    }
  }

  /// Get the saved role name
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  /// Check if user has a specific permission
  static bool hasPermission(List<String> permissions, String name) {
    return permissions.contains(name);
  }

  /// Check if user has ANY of the given permissions
  static bool hasAnyPermission(List<String> permissions, List<String> names) {
    return names.any((name) => permissions.contains(name));
  }

  /// Check if user has ANY permission starting with the given prefix
  /// e.g., prefix "branch." will match "branch.viewAny", "branch.create", etc.
  static bool hasAnyPermissionWithPrefix(List<String> permissions, String prefix) {
    return permissions.any((p) => p.startsWith(prefix));
  }

  /// Check if user has ANY permission matching ANY of the given prefixes
  /// e.g., prefixes ["attendance.", "shift."] will match any attendance or shift permission
  static bool hasAnyPermissionWithPrefixes(List<String> permissions, List<String> prefixes) {
    return prefixes.any((prefix) => permissions.any((p) => p.startsWith(prefix)));
  }

  /// Clear all saved permissions (call on logout)
  static Future<void> clearPermissions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_permissionsKey);
    await prefs.remove(_roleKey);
  }
}
