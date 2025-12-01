import 'package:flutter/material.dart';
import 'package:sitelogger/features/auth/screens/LoginPage.dart';
import 'package:sitelogger/features/const/SafetyIssue.dart';
import 'package:sitelogger/features/const/StorageService.dart';
import 'package:sitelogger/features/officer/screens/IssuesListPage.dart';
import 'package:sitelogger/features/officer/widgets/StatCard.dart';

class SafetyOfficerDashboard extends StatefulWidget {
  const SafetyOfficerDashboard({super.key});

  @override
  State<SafetyOfficerDashboard> createState() =>
      _SafetyOfficerDashboardState();
}

class _SafetyOfficerDashboardState extends State<SafetyOfficerDashboard> {
  List<SafetyIssue> _issues = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIssues();
  }

  Future<void> _loadIssues() async {
    final issues = await StorageService.getIssues();
    setState(() {
      _issues = issues;
      _isLoading = false;
    });
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  Future<void> _markAsSafe(String id) async {
    await StorageService.updateIssueStatus(id, 'Safe');
    _loadIssues();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Issue marked as Safe'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _navigateToFilteredIssues(String filterType) {
    List<SafetyIssue> filteredIssues;
    String title;

    switch (filterType) {
      case 'all':
        filteredIssues = _issues;
        title = 'All Issues';
        break;
      case 'pending':
        filteredIssues = _issues.where((i) => i.status == 'Pending').toList();
        title = 'Pending Issues';
        break;
      case 'resolved':
        filteredIssues = _issues.where((i) => i.status == 'Safe').toList();
        title = 'Resolved Issues';
        break;
      default:
        filteredIssues = _issues;
        title = 'All Issues';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IssuesListPage(
          issues: filteredIssues,
          title: title,
          onRefresh: _loadIssues,
          canMarkSafe: filterType == 'pending',
          onMarkSafe: filterType == 'pending' ? _markAsSafe : null,
        ),
      ),
    ).then((_) => _loadIssues());
  }

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
    final pendingIssues = _issues.where((i) => i.status == 'Pending').toList();
    final resolvedIssues = _issues.where((i) => i.status == 'Safe').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Safety Officer Dashboard'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadIssues,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.deepOrange.shade50,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              StatCard(
                                title: 'Total Issues',
                                count: _issues.length,
                                icon: Icons.list,
                                color: Colors.blue,
                                onTap: () => _navigateToFilteredIssues('all'),
                              ),
                              StatCard(
                                title: 'Pending',
                                count: pendingIssues.length,
                                icon: Icons.pending,
                                color: Colors.orange,
                                onTap: () =>
                                    _navigateToFilteredIssues('pending'),
                              ),
                              StatCard(
                                title: 'Resolved',
                                count: resolvedIssues.length,
                                icon: Icons.check_circle,
                                color: Colors.green,
                                onTap: () =>
                                    _navigateToFilteredIssues('resolved'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Tap on any card to view details',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.swipe, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Swipe right on pending issues to mark as Safe',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recent Pending Issues',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          pendingIssues.isEmpty
                              ? Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.check_circle_outline,
                                            size: 64,
                                            color: Colors.green.shade300,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'No pending issues',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: pendingIssues
                                      .take(3)
                                      .map((issue) => Dismissible(
                                            key: Key(issue.id),
                                            direction:
                                                DismissDirection.startToEnd,
                                            background: Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 12),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: const Row(
                                                children: [
                                                  Icon(Icons.check_circle,
                                                      color: Colors.white,
                                                      size: 32),
                                                  SizedBox(width: 8),
                                                  Text(
                                                    'Mark Safe',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            confirmDismiss: (direction) async {
                                              return await showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text('Confirm'),
                                                  content: const Text(
                                                      'Mark this issue as Safe?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, false),
                                                      child:
                                                          const Text('Cancel'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, true),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              backgroundColor:
                                                                  Colors.green),
                                                      child: const Text(
                                                          'Confirm',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                            onDismissed: (direction) {
                                              _markAsSafe(issue.id);
                                            },
                                            child: Card(
                                              elevation: 3,
                                              margin: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      _getSeverityColor(
                                                          issue.severity),
                                                  child: Text(
                                                    issue.severity[0]
                                                        .toUpperCase(),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  issue.description,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      'Severity: ${issue.severity}',
                                                      style: TextStyle(
                                                        color:
                                                            _getSeverityColor(
                                                                issue.severity),
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Reported: ${issue.timestamp.toString().split('.')[0]}',
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                                trailing: const Icon(
                                                  Icons.chevron_right,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                          if (pendingIssues.length > 3)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton(
                                onPressed: () =>
                                    _navigateToFilteredIssues('pending'),
                                child: Text(
                                    'View all ${pendingIssues.length} pending issues'),
                              ),
                            ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}




