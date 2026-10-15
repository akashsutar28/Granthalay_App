import 'package:flutter/material.dart';

class Member {
  final String id;
  final String memberCode;
  final String nameMr;
  final String nameEn;
  final String phone;
  final String email;
  final String address;
  final String departmentClass;
  final DateTime registeredDate;

  const Member({
    required this.id,
    required this.memberCode,
    this.nameMr = '',
    this.nameEn = '',
    required this.phone,
    this.email = '',
    this.address = '',
    this.departmentClass = '',
    required this.registeredDate,
  });

  String displayName(Locale locale) {
    if (locale.languageCode == 'mr') {
      return nameMr.isNotEmpty ? nameMr : nameEn;
    } else {
      return nameEn.isNotEmpty ? nameEn : nameMr;
    }
  }

  Member copyWith({
    String? id,
    String? memberCode,
    String? nameMr,
    String? nameEn,
    String? phone,
    String? email,
    String? address,
    String? departmentClass,
    DateTime? registeredDate,
  }) {
    return Member(
      id: id ?? this.id,
      memberCode: memberCode ?? this.memberCode,
      nameMr: nameMr ?? this.nameMr,
      nameEn: nameEn ?? this.nameEn,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      departmentClass: departmentClass ?? this.departmentClass,
      registeredDate: registeredDate ?? this.registeredDate,
    );
  }

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id']?.toString() ?? '',
      memberCode: json['memberCode'] as String? ?? json['code'] as String? ?? '',
      nameMr: json['nameMr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      address: json['address'] as String? ?? '',
      departmentClass: json['departmentClass'] as String? ?? '',
      registeredDate: json['registeredDate'] != null
          ? DateTime.tryParse(json['registeredDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberCode': memberCode,
      'nameMr': nameMr,
      'nameEn': nameEn,
      'phone': phone,
      'email': email,
      'address': address,
      'departmentClass': departmentClass,
      'registeredDate': registeredDate.toIso8601String(),
    };
  }
}
