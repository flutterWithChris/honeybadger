import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/proposals/model/proposal.dart';

class ProposalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Proposal?> fetchProposal(String projectId, String proposalId) async {
    try {
      _firestore
          .collection('projects')
          .doc(projectId)
          .collection('proposals')
          .doc(proposalId)
          .get();
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return null;
  }

  Future<void> sendProposal(Proposal proposal) async {
    try {
      _firestore
          .collection('projects')
          .doc(proposal.jobId)
          .collection('proposals')
          .doc(proposal.id)
          .set(proposal.toJson());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error sending proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<Proposal?> updateProposal(Proposal proposal) async {
    try {
      _firestore
          .collection('projects')
          .doc(proposal.jobId)
          .collection('proposals')
          .doc(proposal.id)
          .set(proposal.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error updating proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return null;
  }

  Future<Proposal?> deleteProposal(Proposal proposal) async {
    try {
      _firestore
          .collection('projects')
          .doc(proposal.jobId)
          .collection('proposals')
          .doc(proposal.id)
          .delete();
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

  Future<List<Proposal>> fetchSentProposals(String freelancerId) async {
    try {
      return await _firestore
          .collection('users')
          .doc(freelancerId)
          .collection('proposals')
          .get()
          .then((value) =>
              value.docs.map((e) => Proposal.fromJson(e.data())).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return [];
    }
  }

  /// Fetch proposals by job id, ignoring those that are draft
  Future<List<Proposal>> fetchProposalsByProject(String projectId) async {
    try {
      return await _firestore
          .collection('projects')
          .doc(projectId)
          .collection('proposals')
          .get()
          .then((value) =>
              value.docs.map((e) => Proposal.fromJson(e.data())).toList());
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return [];
    }
  }

  Future<List<Proposal>> fetchProposalsByFreelancerId(
      String freelancerId) async {
    try {
      /// Get list of sent proposals for freelancer
      /// use the project & proposal ids to get the proposals
      /// from the projects collection
      List<Proposal> freelancerProposals = await _firestore
          .collection('users')
          .doc(freelancerId)
          .collection('proposals')
          .get()
          .then((value) =>
              value.docs.map((e) => Proposal.fromJson(e.data())).toList());
      List<Proposal> proposals = [];
      for (var proposal in freelancerProposals) {
        await _firestore
            .collection('projects')
            .doc(proposal.jobId)
            .collection(proposal.id!)
            .get()
            .then((value) =>
                value.docs.map((e) => Proposal.fromJson(e.data())).toList())
            .then((value) => proposals.addAll(value));
      }
      return proposals;
    } on FirebaseException catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error fetching proposals'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return [];
    }
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
