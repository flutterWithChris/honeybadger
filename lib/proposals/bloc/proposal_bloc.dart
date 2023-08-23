import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/message/bloc/messages_bloc.dart';
import 'package:outsourcedx/profile/bloc/profile_bloc.dart';
import 'package:outsourcedx/profile/model/user.dart';
import 'package:outsourcedx/projects/model/project.dart';
import 'package:outsourcedx/projects/model/work_submission.dart';
import 'package:outsourcedx/projects/repository/projects_repository.dart';
import 'package:outsourcedx/proposals/model/milestone.dart';
import 'package:outsourcedx/proposals/model/proposal.dart';
import 'package:outsourcedx/proposals/repo/proposal_repository.dart';
import 'package:list_ext/list_ext.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

part 'proposal_event.dart';
part 'proposal_state.dart';

class ProposalBloc extends Bloc<ProposalsEvent, ProposalState> {
  final ProposalRepository _proposalRepository;
  final MessagesBloc _messagesBloc;
  final ProjectsRepository _projectsRepository;
  final ProfileBloc _profileBloc;
  ProposalBloc(
      {required ProposalRepository proposalRepository,
      required MessagesBloc messagesBloc,
      required ProjectsRepository projectsRepository,
      required ProfileBloc profileBloc})
      : _proposalRepository = proposalRepository,
        _messagesBloc = messagesBloc,
        _projectsRepository = projectsRepository,
        _profileBloc = profileBloc,
        super(const ProposalLoading()) {
    print('Proposal state: $state');
    on<LoadProposal>((event, emit) async {
      if (state is ProposalLoading == false) emit(const ProposalLoading());
      Proposal? currentProposal;
      await emit.forEach(
        _proposalRepository.fetchProposal(event.projectId, event.userId),
        onData: (data) {
          if (data != null) {
            print('Found proposal: ${data.id}');
            if (data.status == ProposalStatus.draft) {
              return ProposalStarted(proposal: data);
            } else {
              return ProposalLoaded(data);
            }
          } else {
            print('No proposal found');
            return ProposalLoaded(data);
          }
        },
      );
    });
    on<LoadProposals>((event, emit) async {
      if (state is ProposalLoading == false) emit(const ProposalLoading());
      if (_profileBloc.state.user!.userType == UserType.client) {
        await emit.forEach(
          _proposalRepository.fetchProposalsByStatus(
              event.project.id!,
              event.project.status == ProjectStatus.inProgress
                  ? ProposalStatus.accepted
                  : ProposalStatus.sent),
          onData: (data) {
            List<Proposal> proposals = data?.toList() ?? [];

            return ProposalsLoaded(proposals, const []);
          },
        );
        return;
      }
      await emit.forEach(
        _proposalRepository.fetchProposalsByFreelancerId(event.userId),
        onData: (data) {
          List<Proposal> proposals = data.toList();
          List<Proposal> draftProposals = data
              .where((element) => element.status == ProposalStatus.draft)
              .toList();
          return ProposalsLoaded(proposals, draftProposals);
        },
      );
    });
    on<StartProposal>((event, emit) async {
      emit(const ProposalLoading());
      String proposalId =
          await _proposalRepository.createProposal(event.proposal);

      emit(ProposalStarted(proposal: event.proposal.copyWith(id: proposalId)));
    });
    on<AutoSaveProposal>((event, emit) async {
      try {
        final proposal = event.proposal.copyWith(savedAt: DateTime.now());
        emit(ProposalSaving(proposal: proposal));
        await Future.delayed(const Duration(milliseconds: 1000));

        await _proposalRepository.updateProposal(event.proposal);
        emit(ProposalStarted(proposal: proposal));
      } catch (e) {
        print(e);
        emit(ProposalsError());
      }
    });
    on<SendProposal>((event, emit) async {
      emit(ProposalSending(event.proposal));
      try {
        final newProposal = event.proposal;
        await _proposalRepository.sendProposal(newProposal);
        // _messagesBloc.add(event)
        // _messagesBloc.add(
        //   SendMessage(
        //       message: Message(
        //           text:
        //               'You have a new proposal from ${newProposal.freelancerName}',
        //           user: User(
        //             id: newProposal.freelancerId!,
        //             name: newProposal.freelancerName,
        //             role: 'Freelancer',
        //           ),
        //           createdAt: DateTime.now(),
        //           mentionedUsers: [User(id: newProposal.clientId!)])),
        // );
        // emit(ProposalSent(newProposal));
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Proposal Sent!'),
          backgroundColor: Colors.green,
          // action: SnackBarAction(
          //   label: 'Undo',
          //   onPressed: () {

          //   },
          // ),
        ));
        await Future.delayed(const Duration(seconds: 2),
            () => emit(ProposalLoaded(newProposal)));
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
    });
    on<AcceptProposal>((event, emit) async {
      emit(const ProposalLoading());
      try {
        final newProposal = event.proposal;
        await _proposalRepository.acceptProposal(newProposal);
        await _projectsRepository.updateProjectStatus(
            event.proposal.projectId!, ProjectStatus.inProgress);
        await Future.delayed(const Duration(seconds: 1));
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content:
              Text('Proposal Accepted!', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ));
        emit(ProposalLoaded(newProposal));
      } catch (e) {
        print(e);
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Error Accepting Proposal!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ));
        emit(ProposalsError());
      }
    });
    on<FundMilestone>((event, emit) async {
      if (state is ProposalLoaded) {
        final proposal = event.proposal;
        Proposal updatedProposal = proposal.copyWith(
          milestones: proposal.milestones?.map((milestone) {
            if (milestone.id == event.milestone.id) {
              return milestone.copyWith(funded: true);
            }
            return milestone;
          }).toList(),
        );
        await _proposalRepository.updateProposal(event.proposal);
        await Future.delayed(const Duration(seconds: 1));
        emit(ProposalLoaded(updatedProposal));
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
        emit(const ProposalLoading());
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
        int? updatedBudget;
        final proposal = state.proposal!;

        // replace the milestone with the updated one
        List<Milestone> milestones = proposal.milestones ?? [];
        Milestone? milestone = milestones.firstWhereOrNull(
            (milestone) => milestone.id == event.milestone.id);
        int? lastMilestoneAmount = milestone?.amount;
        print('Last Milestone Amount: $lastMilestoneAmount');
        milestones.remove(milestone); // remove the old milestone from the list
        milestones.add(event.milestone);
        // Update the budget, if the milestone has an amount
        // if the milestone has no amount, then we subtract the amount from the budget
        if (event.milestone.amount != null &&
            event.milestone.amount != lastMilestoneAmount) {
          updatedBudget = proposal.milestones!
              .map((e) => e.amount)
              .reduce((value, element) => value! + element!);
          print('Updated Budget: $updatedBudget');
        } else if (event.milestone.amount == null &&
            event.milestone.amount != lastMilestoneAmount) {
          updatedBudget = proposal.budgetTotal! - lastMilestoneAmount!;
          print('Updated Budget: $updatedBudget');
        }

        Proposal updatedProposal = proposal.copyWith(
            milestones: milestones, budgetTotal: updatedBudget);
        emit(ProposalStarted(proposal: updatedProposal));
      }
    });
    on<UpdateDescription>((event, emit) async {
      if (state is ProposalStarted) {
        final proposal = state.proposal;
        // replace the milestone with the updated one
        String description = event.description;
        Proposal updatedProposal = proposal!.copyWith(description: description);
        emit(ProposalStarted(
            proposal: updatedProposal.copyWith(savedAt: DateTime.now())));
      }
    });
    on<DeleteMilestone>((event, emit) async {
      if (state is ProposalStarted) {
        final proposal = state.proposal;
        emit(const ProposalLoading());
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
    on<SubmitWork>((event, emit) async {
      try {
        emit(ProposalLoading(proposal: state.proposal));
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Submitting Work...'),
          ),
        );

        final proposal = state.proposal;

        WorkSubmission workSubmission = WorkSubmission(
          id: const Uuid().v4(),
          projectId: event.proposal.projectId,
          proposalId: event.proposal.id,
          milestoneId: event.milestone.id,
          description: event.description,
          userId: _profileBloc.state.user!.id,
          urls: event.urls,
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );

        // Check if milestone files or images are present then upload in parallel
        if (event.files != null || event.images != null) {
          List<Future<String>?> fileFutures = [];
          List<Future<String>?> imageFutures = [];
          List<String>? fileUrls;
          List<String>? imageUrls;
          if (event.files != null) {
            fileFutures.addAll(event.files!.map((file) => _proposalRepository
                .uploadMilestoneFile(event.proposal, event.milestone, file)));
            fileUrls =
                await Future.wait(fileFutures.whereType<Future<String>>());
          }

          if (event.images != null) {
            imageFutures.addAll(event.images!.map((image) => _proposalRepository
                .uploadMilestoneImage(event.proposal, event.milestone, image)));
            imageUrls =
                await Future.wait(imageFutures.whereType<Future<String>>());
          }

          workSubmission =
              workSubmission.copyWith(files: fileUrls, images: imageUrls);
        }

        Proposal updatedProposal = proposal!.copyWith(
          milestones: proposal.milestones?.map((milestone) {
            if (milestone.id == event.milestone.id) {
              return milestone.copyWith(workSubmission: workSubmission);
            }
            return milestone;
          }).toList(),
        );

        await _proposalRepository.updateProposal(updatedProposal);
        emit(ProposalUpdated(updatedProposal));
        scaffoldKey.currentState!.showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Row(
              children: [
                Icon(MdiIcons.checkBold, color: Colors.white, size: 14.0),
                const SizedBox(width: 8.0),
                const Text('Work Submitted!',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            backgroundColor: Colors.green,
          ),
        );
        emit(ProposalLoaded(updatedProposal));
      } catch (e) {
        print(e);
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text('Error Submitting Work!'),
            backgroundColor: Colors.red,
          ),
        );
        emit(ProposalsError());
      }
    });
  }
}
