import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProposalRepository {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<Proposal?> fetchProposal(String jobId) async {
    try {
      final List<dynamic> response =
          await supabaseClient.from('proposals').select().eq('jobId', jobId);
      print(response);
      if (response.isEmpty) {
        return null;
      } else {
        return Proposal.fromJson(response.first);
      }
    } catch (e) {
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
      final response = await supabaseClient.from('proposals').insert([
        proposal.toJson(),
      ]);
    } catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error sending proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<Proposal?> saveProposal(Proposal proposal) async {
    try {
      final response = await supabaseClient.from('proposals').insert([
        proposal.toJson(),
      ]);
      return response;
    } catch (e) {
      print(e);
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text('Error saving proposal'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
    return null;
  }

  Future<Proposal?> updateProposal(Proposal proposal) async {
    try {
      final response = await supabaseClient
          .from('proposals')
          .update(
            proposal.toJson(),
          )
          .eq('id', proposal.id);
      return response;
    } catch (e) {
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
      final response =
          await supabaseClient.from('proposals').delete().eq('id', proposal.id);
      return response;
    } catch (e) {
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

  Future<List<Proposal>> fetchProposals(String userId) async {
    try {
      final response = await supabaseClient
          .from('proposals')
          .select()
          .eq('freelancer', userId);
      return response.data!.map((e) => Proposal.fromJson(e)).toList();
    } catch (e) {
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
  Future<List<Proposal>> fetchProposalsByJobId(String jobId) async {
    try {
      final response = await supabaseClient
          .from('proposals')
          .select()
          .eq('jobId', jobId)
          .neq('status', ProposalStatus.draft)
          .order('createdAt', ascending: false);
      return response.data!.map((e) => Proposal.fromJson(e)).toList();
    } catch (e) {
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
      final response = await supabaseClient
          .from('proposals')
          .select()
          .eq('freelancer', freelancerId)
          .order('createdAt', ascending: false);
      return response.data!.map((e) => Proposal.fromJson(e)).toList();
    } catch (e) {
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

  Future<List<Proposal>> fetchProposalsByClientId(String clientId) async {
    try {
      final response = await supabaseClient
          .from('proposals')
          .select()
          .eq('client', clientId)
          .order('createdAt', ascending: false);
      return response.data!.map((e) => Proposal.fromJson(e)).toList();
    } catch (e) {
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

  Future<List<Proposal>> fetchProposalsByStatus(
      String jobId, ProposalStatus status) async {
    return [];
  }
}
