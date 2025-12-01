
import 'package:flutter/material.dart';
import 'package:sitelogger/features/const/SafetyIssue.dart';

class IssuesListPage extends StatelessWidget {
  final List<SafetyIssue> issues;
  final String title;
  final VoidCallback onRefresh;
  final bool canMarkSafe;
  final Function(String)? onMarkSafe;

  const IssuesListPage({
    super.key,
    required this.issues,
    required this.title,
    required this.onRefresh,
    this.canMarkSafe = false,
    this.onMarkSafe,
  });

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: issues.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No issues found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: issues.length,
              itemBuilder: (context, index) {
                final issue = issues[index];

                if (canMarkSafe && onMarkSafe != null) {
                  return Dismissible(
                    key: Key(issue.id),
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 32),
                          SizedBox(width: 8),
                          Text(
                            'Mark Safe',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Confirm'),
                          content: const Text('Mark this issue as Safe?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              child: const Text('Confirm',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      onMarkSafe!(issue.id);
                      Navigator.pop(context);
                    },
                    child: _buildIssueCard(issue),
                  );
                } else {
                  return _buildIssueCard(issue);
                }
              },
            ),
    );
  }

  Widget _buildIssueCard(SafetyIssue issue) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getSeverityColor(issue.severity),
          child: Text(
            issue.severity[0].toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          issue.description,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Severity: ${issue.severity}',
              style: TextStyle(
                color: _getSeverityColor(issue.severity),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Status: ${issue.status}',
              style: TextStyle(
                color: issue.status == 'Safe' ? Colors.green : Colors.orange,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Reported by: ${issue.reportedBy}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              'Time: ${issue.timestamp.toString().split('.')[0]}',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Icon(
          issue.status == 'Safe' ? Icons.check_circle : Icons.warning,
          color: issue.status == 'Safe' ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}
