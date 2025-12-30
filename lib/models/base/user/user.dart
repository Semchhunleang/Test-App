import 'dart:convert';

import 'package:umgkh_mobile/models/base/user/department.dart';
import 'package:umgkh_mobile/models/base/user/work_location.dart';

class User {
  final int id;
  final int userId;
  final String name;
  final String username;
  final String registrationNumber;
  final String jobTitle;
  final String? rank;
  final String? userLevel;
  final String? subRank;
  final String? mobilePhone;
  final String? workPhone;
  final String? workEmail;
  final List? faceLandmarks;
  final WorkLocation? workLocation;
  final Department? department;
  final User? manager;

  User({
    required this.id,
    required this.userId,
    required this.name,
    required this.username,
    required this.registrationNumber,
    required this.jobTitle,
    this.rank,
    this.userLevel,
    this.subRank,
    this.mobilePhone,
    this.workPhone,
    this.workEmail,
    this.faceLandmarks,
    this.workLocation,
    this.department,
    this.manager,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Department and Department
    Department? department;
    if (json['department'] != null && json['department']['id'] != null) {
      department = Department.fromJson(json['department']);
    }
    WorkLocation? workLocation;
    if (json['work_location'] != null && json['work_location']['id'] != null) {
      workLocation = WorkLocation.fromJson(json['work_location']);
    }
    List? faceLandmarks;
    if (json['face_landmarks'] == null || json['face_landmarks'] != "") {
      faceLandmarks = jsonDecode(json['face_landmarks'] ?? "[{},{}]");
    }
    return User(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      registrationNumber: json['registration_number'] ?? '',
      jobTitle: json['job_title'] ?? '',
      rank: json['rank'],
      userLevel: json['user_level'],
      subRank: json['sub_rank'],
      mobilePhone: json['mobile_phone'],
      workPhone: json['work_phone'],
      workEmail: json['work_email'],
      faceLandmarks: faceLandmarks,
      workLocation: workLocation,
      department: department,
      manager: json['manager'] != null && json['manager']['id'] != null
          ? User.managerFromJson(json['manager'])
          : null,
    );
  }
  factory User.managerFromJson(dynamic json) {
    Department? department;
    if (json['department']['id'] != null) {
      department = Department.fromJson(json['department']);
    }
    WorkLocation? workLocation;
    if (json['work_location']['id'] != null) {
      workLocation = WorkLocation.fromJson(json['work_location']);
    }
    return User(
        // id: json['id'],
        // userId: json['user_id'],
        id: (json['id'] is int) ? json['id'] as int : 0,
        userId: (json['user_id'] is int) ? json['user_id'] as int : 0,
        name: json['name'],
        username: json['username'] ?? '',
        registrationNumber: json['registration_number'] ?? '',
        jobTitle: json['job_title'] ?? '',
        rank: json['rank'],
        userLevel: json['user_level'],
        subRank: json['sub_rank'],
        mobilePhone: json['mobile_phone'],
        workPhone: json['work_phone'],
        workEmail: json['work_email'],
        faceLandmarks: jsonDecode(json['face_landmarks'] ?? "[{},{}]"),
        workLocation: workLocation,
        department: department,
        manager: null);
  }

  factory User.defaultUser({required int id, required String name}) {
    return User(
        id: id,
        userId: 0,
        name: name,
        username: '',
        registrationNumber: '',
        jobTitle: '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'username': username,
      'registration_number': registrationNumber,
      'job_title': jobTitle,
    };
  }
}
