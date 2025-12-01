import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitelogger/features/const/SafetyIssue.dart';

class StorageService {
  static const String _issuesKey = 'safety_issues';

  static Future<List<SafetyIssue>> getIssues() async {
    final prefs = await SharedPreferences.getInstance();
    final String? issuesJson = prefs.getString(_issuesKey);
    if (issuesJson == null) return [];

    final List<dynamic> decoded = json.decode(issuesJson);
    return decoded.map((item) => SafetyIssue.fromJson(item)).toList();
  }

  static Future<void> saveIssues(List<SafetyIssue> issues) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(issues.map((i) => i.toJson()).toList());
    await prefs.setString(_issuesKey, encoded);
  }

  static Future<void> addIssue(SafetyIssue issue) async {
    final issues = await getIssues();
    issues.add(issue);
    await saveIssues(issues);
  }

  static Future<void> updateIssueStatus(String id, String newStatus) async {
    final issues = await getIssues();
    final index = issues.indexWhere((i) => i.id == id);
    if (index != -1) {
      final updatedIssue = SafetyIssue(
        id: issues[index].id,
        description: issues[index].description,
        severity: issues[index].severity,
        status: newStatus,
        timestamp: issues[index].timestamp,
        reportedBy: issues[index].reportedBy,
      );
      issues[index] = updatedIssue;
      await saveIssues(issues);
    }
  }
}

