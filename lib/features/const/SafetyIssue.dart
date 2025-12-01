class SafetyIssue {
  final String id;
  final String description;
  final String severity;
  final String status;
  final DateTime timestamp;
  final String reportedBy;

  SafetyIssue({
    required this.id,
    required this.description,
    required this.severity,
    required this.status,
    required this.timestamp,
    required this.reportedBy,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'severity': severity,
        'status': status,
        'timestamp': timestamp.toIso8601String(),
        'reportedBy': reportedBy,
      };

  factory SafetyIssue.fromJson(Map<String, dynamic> json) => SafetyIssue(
        id: json['id'],
        description: json['description'],
        severity: json['severity'],
        status: json['status'],
        timestamp: DateTime.parse(json['timestamp']),
        reportedBy: json['reportedBy'],
      );
}

