

enum LeadStatus { New, Contacted, Lost, Converted }


class Lead {
  final int? id;
  final String name;
  final String phone;
  final String email;
  final String notes;
  final LeadStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Lead({
    this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.notes,
    this.status = LeadStatus.New,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'notes': notes,
      'status': status.index, 
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

 
  factory Lead.fromMap(Map<String, dynamic> map) {
    return Lead(
      id: map['id'] as int,
      name: map['name'] as String,
      phone: map['phone'] as String,
      email: map['email'] as String,
      notes: map['notes'] as String,
      status: LeadStatus.values[map['status'] as int],
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'notes': notes,
    
      'status': status.name, 
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
  
 
  Lead copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? notes,
    LeadStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}