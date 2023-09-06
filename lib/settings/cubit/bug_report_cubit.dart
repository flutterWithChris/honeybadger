import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:outsourcedx/core/constants.dart';
import 'package:outsourcedx/settings/models/bug.dart';
import 'package:outsourcedx/settings/repository/bug_repository.dart';

part 'bug_report_state.dart';

class BugReportCubit extends Cubit<BugReportState> {
  final BugRepository _bugRepository;
  BugReportCubit({
    required BugRepository bugRepository,
  })  : _bugRepository = bugRepository,
        super(BugReportInitial());
  void reportBug(Bug bug) async {
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: 2.seconds,
        content: const Text('Sending report...'),
      ),
    );
    emit(BugReportLoading());
    try {
      await _bugRepository.reportBug(bug);
      await Future.delayed(const Duration(seconds: 1));
      scaffoldKey.currentState!.showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Report sent! Thank you.',
            style: TextStyle(color: Colors.white)),
      ));
      emit(BugReportLoaded());
    } catch (e) {
      emit(BugReportError());
    }
  }
}
