import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/proposals/model/proposal.dart';

class ProposalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<Proposal?> fetchProposal(String projectId, String userId) {
    try {
      return _firestore
          .collection('proposals')
          .where('projectId', isEqualTo: projectId)
          .where('freelancerId', isEqualTo: userId)
          .snapshots()
          .map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          return Proposal.fromDocument(snapshot.docs.first);
        }
        return null;
      });
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return const Stream.empty();
  }

  Future<String> createProposal(Proposal proposal) async {
    try {
      var docRef = _firestore.collection('proposals').doc();

      await docRef.set(proposal.toDocument());
      return docRef.id;
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error sending proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
      rethrow;
    }
  }

  Future<void> sendProposal(Proposal proposal) async {
    try {
      await _firestore
          .collection('proposals')
          .where('projectId', isEqualTo: proposal.projectId)
          .where('freelancerId', isEqualTo: proposal.freelancerId)
          .get()
          .then((value) => value.docs.forEach((element) async {
                await _firestore
                    .collection('proposals')
                    .doc(element.id)
                    .update(proposal.toDocument());
              }));
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error sending proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
      rethrow;
    }
  }

  Future<void> updateProposal(Proposal proposal) async {
    try {
      _firestore
          .collection('proposals')
          .where('projectId', isEqualTo: proposal.projectId)
          .where('freelancerId', isEqualTo: proposal.freelancerId)
          .get()
          .then((value) => value.docs.forEach((element) {
                _firestore
                    .collection('proposals')
                    .doc(element.id)
                    .update(proposal.toDocument());
              }));
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error updating proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
      rethrow;
    }
  }

  Future<Proposal?> deleteProposal(Proposal proposal) async {
    try {
      _firestore.collection('proposals').doc(proposal.id).delete();
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error deleting proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return null;
  }

  Future<Proposal?> selectProposal(Proposal proposal) async {
    return null;
  }

  Stream<List<Proposal>> fetchSentProposals(String freelancerId) {
    try {
      return _firestore
          .collection('proposals')
          .where('freelancerId', isEqualTo: freelancerId)
          .where('status', isEqualTo: 'sent')
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Proposal.fromDocument(e)).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return const Stream.empty();
    }
  }

  Stream<List<Proposal>> fetchDraftProposals(String freelancerId) {
    try {
      return _firestore
          .collection('proposals')
          .where('freelancerId', isEqualTo: freelancerId)
          .where('status', isEqualTo: 'draft')
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Proposal.fromDocument(e)).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return const Stream.empty();
    }
  }

  /// Fetch proposals by job id, ignoring those that are draft
  Stream<List<Proposal>?> fetchProposalsByProject(String projectId) {
    try {
      return _firestore
          .collection('proposals')
          .where('projectId', isEqualTo: projectId)
          .where('status', isNotEqualTo: ProposalStatus.draft.toString())
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Proposal.fromDocument(e)).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return const Stream.empty();
    }
  }

  Stream<List<Proposal>> fetchProposalsByFreelancerId(String freelancerId) {
    try {
      return _firestore
          .collection('proposals')
          .where('freelancerId', isEqualTo: freelancerId)
          .snapshots()
          .map((event) =>
              event.docs.map((e) => Proposal.fromDocument(e)).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return const Stream.empty();
    }

    // Future<List<Proposal>> fetchProposalsByClientId(String clientId) async {
    //   try {
    //     final response = await supabaseClient
    //         .from('proposals')
    //         .select()
    //         .eq('client', clientId)
    //         .order('createdAt', ascending: false);
    //     return response.data!.map((e) => Proposal.fromJson(e)).toList();
    //   } on FirebaseException catch (e) {
    //     print(e);
    //     scaffoldKey.currentState!.showSnackBar(
    //       const SnackBar(
    //         content: Text('Error fetching proposals'),
    //         backgroundColor: Colors.redAccent,
    //       ),
    //     );
    //     return [];
    //   }
    // }

    Future<List<Proposal>> fetchProposalsByStatus(
        String jobId, ProposalStatus status) async {
      return [];
    }
  }
}
