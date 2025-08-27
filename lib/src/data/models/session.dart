enum SessionStatus {
  pending,
  active,
  refused,
  endedByUser,
  expired,
  canceled,
  unknown // Handle unexpected case
}

class Session {
  final String id;
  final int initiatorId;
  final int recipientId;
  final SessionStatus status;

  Session({
    required this.id,
    required this.initiatorId,
    required this.recipientId,
    required this.status,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['ID'],
      initiatorId: json['InitiatorID'],
      recipientId: json['RecipientID'],
      status: _parseStatus(json['Status']),
    );
  }

  // Private Thinker Artisan to translate the status string.
  static SessionStatus _parseStatus(String statusStr) {
    switch (statusStr) {
      case 'PENDING':
        return SessionStatus.pending;
      case 'ACTIVE':
        return SessionStatus.active;
      // ... Add other here
      default:
        return SessionStatus.unknown;
    }
  }
}