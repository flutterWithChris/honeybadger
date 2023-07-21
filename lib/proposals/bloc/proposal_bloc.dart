import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/proposals/model/milestone.dart';
import 'package:honeybadger/proposals/model/proposal.dart';
import 'package:honeybadger/message/bloc/messages_bloc.dart';
import 'package:honeybadger/proposals/repo/proposal_repository.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'proposal_event.dart';
part 'proposal_state.dart';

class ProposalBloc extends Bloc<ProposalsEvent, ProposalState> {
  final ProposalRepository _proposalRepository;
  final MessagesBloc _messagesBloc;
  ProposalBloc(
      {required ProposalRepository proposalRepository,
      required MessagesBloc messagesBloc})
      : _proposalRepository = proposalRepository,
        _messagesBloc = messagesBloc,
        super(ProposalLoading()) {
    on<LoadProposal>((event, emit) async {
      if (state is ProposalLoading == false) emit(ProposalLoading());
      Proposal? currentProposal;
      // final proposal = await _proposalRepository.fetchProposal(event.jobId);
      emit(ProposalLoaded(currentProposal));
    });
    on<StartProposal>((event, emit) {
      emit(ProposalStarted(proposal: Proposal(jobId: event.jobId)));
    });
    on<AutoSaveProposal>((event, emit) async {
      try {
        final proposal = event.proposal.copyWith(savedAt: DateTime.now());
        emit(ProposalSaving(proposal: proposal));
        await Future.delayed(const Duration(milliseconds: 1000));
        // Proposal proposal =  await _proposalRepository.saveProposal(event.proposal);
        emit(ProposalStarted(proposal: proposal));
      } catch (e) {
        print(e);
        emit(ProposalsError());
      }
    });
    on<SendProposal>((event, emit) async {
      if (state is ProposalStarted) {
        try {
          final newProposal = event.proposal;
          await Future.delayed(const Duration(seconds: 1));
          await _proposalRepository.sendProposal(newProposal);
          // _messagesBloc.add(event)
          _messagesBloc.add(
            SendMessage(
                message: Message(
                    text:
                        'You have a new proposal from ${newProposal.freelancerName}',
                    user: User(
                      id: newProposal.freelancerId!,
                      name: newProposal.freelancerName,
                      role: 'Freelancer',
                    ),
                    createdAt: DateTime.now(),
                    mentionedUsers: [User(id: newProposal.clientId!)])),
          );
          emit(ProposalSent(newProposal));
        } catch (e) {
          scaffoldKey.currentState!.showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Error Sending Proposal!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
          emit(ProposalsError());
        }
      }
    });
    on<UpdateProposal>((event, emit) async {
      if (state is ProposalLoaded) {
        final newProposal = event.proposal;
        await Future.delayed(const Duration(seconds: 1));
        emit(ProposalLoaded(newProposal));
      }
    });
    on<DeleteProposal>((event, emit) async {
      if (state is ProposalStarted && event.proposal != null) {
        await _proposalRepository.deleteProposal(event.proposal!);
        emit(ProposalDeleted(event.proposal));
        await Future.delayed(const Duration(milliseconds: 400));
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: const Text('Proposal Deleted!'),
            backgroundColor: Colors.redAccent,
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {},
            ),
          ),
        );
      } else {
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Canceled Proposal'),
          ),
        );
      }
      emit(const ProposalLoaded(null));
    });
    on<AddMilestone>((event, emit) async {
      if (state is ProposalStarted) {
        final proposal = state.proposal?.copyWith(
          milestones: [...(state.proposal?.milestones ?? []), event.milestone],
        );
        emit(ProposalLoading());
        print('PRoposal Milestones: ${proposal?.milestones?.toString()}');
        emit(ProposalStarted(proposal: proposal));
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Milestone Added'),
          ),
        );
      }
    });
    on<UpdateMilestone>((event, emit) async {
      if (state is ProposalStarted) {
        final proposal = state.proposal;
        final index = proposal?.milestones?.indexOf(event.milestone);
        proposal?.milestones?[index!] = event.milestone;
        emit(ProposalStarted(proposal: proposal));
      }
    });
    on<DeleteMilestone>((event, emit) async {
      if (state is ProposalStarted) {
        final proposal = state.proposal;
        emit(ProposalLoading());
        proposal?.milestones?.remove(event.milestone);
        emit(ProposalStarted(proposal: proposal));
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.redAccent,
              content: const Text('Milestone Deleted',
                  style: TextStyle(color: Colors.white)),
              action: SnackBarAction(
                label: 'Undo',
                textColor: Colors.white,
                onPressed: () {},
              )),
        );
      }
    });
  }
}
