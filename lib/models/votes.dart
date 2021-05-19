import 'package:cloud_firestore/cloud_firestore.dart';

class Votes {
  String name;
  int vote;
  final DocumentSnapshot snapshot;
  final DocumentReference reference;
  final String documentID;

  Votes({
    this.name,
    this.vote,
    this.snapshot,
    this.reference,
    this.documentID,
  });

  factory Votes.fromFirestore(DocumentSnapshot snapshot) {
    if (snapshot == null) return null;
    var map = snapshot.data();

    return Votes(
      name: map['name'],
      vote: map['vote'],
      snapshot: snapshot,
      reference: snapshot.reference,
      documentID: snapshot.id,
    );
  }

  factory Votes.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Votes(
      name: map['name'],
      vote: map['vote'],
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'vote': vote,
      };

  Votes copyWith({
    String name,
    int vote,
  }) {
    return Votes(
      name: name ?? this.name,
      vote: vote ?? this.vote,
    );
  }

  @override
  String toString() {
    return '${name.toString()}, ${vote.toString()}, ';
  }

  @override
  bool operator ==(other) => other is Votes && documentID == other.documentID;

  int get hashCode => documentID.hashCode;
}
