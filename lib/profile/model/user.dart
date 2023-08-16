import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:OutsourcedX/profile/model/category.dart';
import 'package:OutsourcedX/profile/model/skill.dart';
import 'package:OutsourcedX/profile/review.dart';

enum UserType { freelancer, client }

enum CommunicationPreference { message, video, both }

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? company;
  String? industry;
  double? rating;
  int? ratingCount;
  List<Review>? reviews;
  int? jobsCompleted;
  String? phoneNumber;
  String? address;
  String? title;
  int? hourlyRate;
  UserType? userType;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? photoUrl;
  String? bio;
  String? stripeAccountId;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<dynamic>? projectIds;
  List<dynamic>? proposalIds;
  List<Skill>? skills;
  List<Category>? categories;
  CommunicationPreference? communicationPreference;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.company,
    this.industry,
    this.rating,
    this.ratingCount,
    this.reviews,
    this.jobsCompleted,
    this.phoneNumber,
    this.address,
    this.title,
    this.hourlyRate,
    this.userType,
    this.city,
    this.state,
    this.zip,
    this.country,
    this.photoUrl,
    this.bio,
    this.stripeAccountId,
    this.createdAt,
    this.updatedAt,
    this.projectIds,
    this.proposalIds,
    this.skills,
    this.categories,
    this.communicationPreference,
  });

  User.fromDocument(DocumentSnapshot snap) {
    id = snap.id;
    firstName = snap['firstName'];
    lastName = snap['lastName'];
    email = snap['email'];
    company = snap['company'];
    industry = snap['industry'];
    rating = snap['rating'];
    ratingCount = snap['ratingCount'];
    if (snap['reviews'] != null) {
      reviews = [];
      snap['reviews'].forEach((v) {
        reviews?.add(Review.fromJson(v));
      });
    }
    jobsCompleted = snap['jobsCompleted'];
    phoneNumber = snap['phoneNumber'];
    address = snap['address'];
    title = snap['title'];
    hourlyRate = snap['hourlyRate'];
    userType = snap['userType'] == 'freelancer'
        ? UserType.freelancer
        : UserType.client;
    city = snap['city'];
    state = snap['state'];
    zip = snap['zip'];
    country = snap['country'];
    photoUrl = snap['photoUrl'];
    bio = snap['bio'];
    stripeAccountId = snap['stripeAccountId'];
    createdAt = DateTime.tryParse(snap['createdAt'] ?? '');
    updatedAt = DateTime.tryParse(snap['updatedAt'] ?? '');
    projectIds = snap['projectIds'];
    proposalIds = snap['proposalIds'];
    if (snap['skills'] != null) {
      skills = [];
      snap['skills'].forEach((v) {
        skills?.add(Skill.fromJson(v));
      });
    }
    if (snap['categories'] != null) {
      categories = [];
      snap['categories'].forEach((v) {
        categories?.add(Category.fromJson(v));
      });
    }
    if (snap['communicationPreference'] != null) {
      communicationPreference = snap['communicationPreference'] == 'message'
          ? CommunicationPreference.message
          : snap['communicationPreference'] == 'video'
              ? CommunicationPreference.video
              : CommunicationPreference.both;
    }
  }

  // To Document
  Map<String, dynamic> toDocument() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'company': company,
      'industry': industry,
      'rating': rating,
      'ratingCount': ratingCount,
      'reviews': reviews?.map((v) => v.toJson()).toList(),
      'jobsCompleted': jobsCompleted,
      'phoneNumber': phoneNumber,
      'address': address,
      'title': title,
      'hourlyRate': hourlyRate,
      'userType': userType == UserType.freelancer ? 'freelancer' : 'client',
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'photoUrl': photoUrl,
      'bio': bio,
      'stripeAccountId': stripeAccountId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'projectIds': projectIds,
      'proposalIds': proposalIds,
      'skills': skills?.map((v) => v.toDocument()).toList(),
      'categories': categories?.map((v) => v.toDocument()).toList(),
      'communicationPreference':
          communicationPreference == CommunicationPreference.message
              ? 'message'
              : communicationPreference == CommunicationPreference.video
                  ? 'video'
                  : 'both'
    };
  }

  /// CopyWith
  User copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? company,
    String? industry,
    double? rating,
    int? ratingCount,
    List<Review>? reviews,
    int? jobsCompleted,
    String? phoneNumber,
    String? address,
    String? title,
    int? hourlyRate,
    UserType? userType,
    String? city,
    String? state,
    String? zip,
    String? country,
    String? photoUrl,
    String? bio,
    String? stripeAccountId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? projectIds,
    List<Category>? categories,
    List<Skill>? skills,
    CommunicationPreference? communicationPreference,
  }) {
    return User(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      company: company ?? this.company,
      industry: industry ?? this.industry,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      reviews: reviews ?? this.reviews,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      title: title ?? this.title,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      userType: userType ?? this.userType,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      country: country ?? this.country,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      projectIds: projectIds ?? this.projectIds,
      categories: categories ?? this.categories,
      skills: skills ?? this.skills,
      communicationPreference:
          communicationPreference ?? this.communicationPreference,
    );
  }

  // from AlgoliaSearch
  User.fromAlgoliaSearch(Hit hit) {
    id = hit['objectID'];
    firstName = hit['firstName'];
    lastName = hit['lastName'];
    company = hit['company'];
    rating = hit['rating'];
    ratingCount = hit['ratingCount'];
    if (hit['reviews'] != null) {
      reviews = [];
      hit['reviews'].forEach((v) {
        reviews?.add(Review.fromJson(v));
      });
    }
    title = hit['title'];
    hourlyRate = hit['hourlyRate'];
    city = hit['city'];
    state = hit['state'];
    zip = hit['zip'];
    country = hit['country'];
    photoUrl = hit['photoUrl'];
    bio = hit['bio'];
    if (hit['skills'] != null) {
      skills = [];
      hit['skills'].forEach((v) {
        skills?.add(Skill.fromJson(v));
      });
    }
    if (hit['categories'] != null) {
      categories = [];
      hit['categories'].forEach((v) {
        categories?.add(Category.fromJson(v));
      });
    }
  }
}
