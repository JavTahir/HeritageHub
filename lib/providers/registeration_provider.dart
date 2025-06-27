import 'package:family_tree_app/core/services/cloudinary_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import '../models/head_model.dart';
import '../models/family_member_model.dart';
import '../models/temple_model.dart';
import '../core/services/firebase_service.dart';

class RegistrationProvider with ChangeNotifier {
  HeadModel? _headData;
  List<FamilyMemberModel> _familyMembers = [];
  List<TempleModel> _associatedTemples = [];
  FamilyMemberModel? _currentMember;

  HeadModel? get headData => _headData;
  List<FamilyMemberModel> get familyMembers => _familyMembers;
  List<TempleModel> get associatedTemples => _associatedTemples;
  FamilyMemberModel? get currentMember => _currentMember;

  Future<void> saveHeadData(HeadModel head) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final docRef =
          FirebaseService.firestore.collection('heads').doc(user.uid);
      await docRef.set(head.toMap());
      _headData = head.copyWith(id: user.uid);

      await _fetchAssociatedTemples(head.samajName);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to save head data: ${e.toString()}');
    }
  }

  Future<void> addFamilyMember(FamilyMemberModel member) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');
      if (_headData == null) throw Exception('Head data not saved');

      final memberWithHeadId = member.copyWith(headId: _headData!.id);
      final docRef =
          FirebaseService.firestore.collection('familyMembers').doc();
      await docRef.set(memberWithHeadId.toMap());

      _familyMembers.add(memberWithHeadId.copyWith(id: docRef.id));
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add family member: ${e.toString()}');
    }
  }

  Future<bool> loadFamilyData() async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final headDoc = await FirebaseService.firestore
          .collection('heads')
          .doc(user.uid)
          .get();

      if (headDoc.exists) {
        print('2');
        _headData = HeadModel.fromMap(headDoc.data()!..['id'] = user.uid);
        if (_headData?.samajName != null) {
          await _fetchAssociatedTemples(_headData!.samajName!);
        }
        await _loadFamilyMembers();
        return true;
      }

      await _loadCurrentMember();
      return false;
    } catch (e) {
      throw Exception('Failed to load family data: ${e.toString()}');
    }
  }

  Future<void> _loadFamilyMembers() async {
    final user = FirebaseService.auth.currentUser;
    if (user == null || _headData == null) return;

    final membersQuery = await FirebaseService.firestore
        .collection('familyMembers')
        .where('headId', isEqualTo: _headData!.id)
        .get();

    _familyMembers = membersQuery.docs
        .map((doc) => FamilyMemberModel.fromMap(doc.data()..['id'] = doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> _loadCurrentMember() async {
    final user = FirebaseService.auth.currentUser;
    if (user == null) return;

    try {
      final headDoc = await FirebaseService.firestore
          .collection('heads')
          .doc(user.uid)
          .get();

      if (headDoc.exists) {
        _headData = HeadModel.fromMap(headDoc.data()!..['id'] = user.uid);
        await _fetchAssociatedTemples(_headData?.samajName);
        notifyListeners();
        return;
      }

      final memberQuery = await FirebaseService.firestore
          .collection('familyMembers')
          .where('phoneNumber', isEqualTo: user.phoneNumber)
          .limit(1)
          .get();

      if (memberQuery.docs.isNotEmpty) {
        _currentMember = FamilyMemberModel.fromMap(
            memberQuery.docs.first.data()..['id'] = memberQuery.docs.first.id);

        if (_currentMember?.headId != null) {
          final headDoc = await FirebaseService.firestore
              .collection('heads')
              .doc(_currentMember!.headId)
              .get();

          if (headDoc.exists) {
            _headData = HeadModel.fromMap(headDoc.data()!..['id'] = headDoc.id);
            await _fetchAssociatedTemples(_headData?.samajName);
            await _loadFamilyMembersForMember();
          }
        }
        notifyListeners();
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _loadFamilyMembersForMember() async {
    if (_currentMember == null || _currentMember!.headId == null) return;

    try {
      final membersQuery = await FirebaseService.firestore
          .collection('familyMembers')
          .where('headId', isEqualTo: _currentMember!.headId)
          .get();

      _familyMembers = membersQuery.docs
          .map((doc) => FamilyMemberModel.fromMap(doc.data()..['id'] = doc.id))
          .toList();
    } catch (e) {
      print('Error loading family members: $e');
    }
  }

  Future<void> _fetchAssociatedTemples(String? samajName) async {
    if (samajName == null) return;

    try {
      final query = await FirebaseService.firestore
          .collection('temples')
          .where('samaj', isEqualTo: samajName)
          .get();

      _associatedTemples = query.docs
          .map((doc) => TempleModel.fromMap(doc.data()..['id'] = doc.id))
          .toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch temples: ${e.toString()}');
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      final imageUrl = await CloudinaryService.uploadImage(imageFile);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> deleteFamilyMember(String memberId) async {
    try {
      final user = FirebaseService.auth.currentUser;
      if (user == null || _headData == null || user.uid != _headData!.id) {
        throw Exception('Only family head can delete members');
      }

      await FirebaseService.firestore
          .collection('familyMembers')
          .doc(memberId)
          .delete();

      _familyMembers.removeWhere((member) => member.id == memberId);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to delete: ${e.toString()}');
    }
  }

  Future<void> loadTemples() async {
    if (_associatedTemples.isEmpty && _headData?.samajName != null) {
      await _fetchAssociatedTemples(_headData!.samajName!);
    }
  }
}
