import 'package:cloud_firestore/cloud_firestore.dart';

class UserFeedback {
  final String type;
  final String userFeedback;
  final String currentUid;
  final Timestamp timestamp;
  final bool read;
  final bool open;
  final DocumentSnapshot snapshot;
  final DocumentReference reference;
  final String documentID;

  UserFeedback({
    this.type,
    this.userFeedback,
    this.currentUid,
    this.timestamp,
    this.read,
    this.open,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory UserFeedback.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    var map = snapshot.data();

    return UserFeedback(
      type: map['type'],
      userFeedback: map['userFeedback'],
      currentUid: map['currentUid'],
      timestamp: map['timestamp'],
      read: map['read'],
      open: map['open'],
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory UserFeedback.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UserFeedback(
      type: map['type'],
      userFeedback: map['userFeedback'],
      currentUid: map['currentUid'],
      timestamp: map['timestamp'],
      read: map['read'],
      open: map['open'],
    );
  }

  Map<String, dynamic> toMap() => {
        'type': type,
        'userFeedback': userFeedback,
        'currentUid': currentUid,
        'timestamp': timestamp,
        'read': read,
        'open': open,
      };

  UserFeedback copyWith({
    String type,
    String userFeedback,
    String currentUid,
    Timestamp timestamp,
    bool read,
    bool open,
  }) {
    return UserFeedback(
      type: type ?? this.type,
      userFeedback: userFeedback ?? this.userFeedback,
      currentUid: currentUid ?? this.currentUid,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
      open: open ?? this.open,
    );
  }

  @override
  String toString() {
    return '${type.toString()}, ${userFeedback.toString()}, ${currentUid.toString()}, ${timestamp.toString()}, ${read.toString()}, ${open.toString()}, ';
  }

  @override
  bool operator ==(other) =>
      other is UserFeedback && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
}
