part of 'bug_report_cubit.dart';

sealed class BugReportState extends Equatable {
  const BugReportState();

  @override
  List<Object> get props => [];
}

final class BugReportInitial extends BugReportState {}

final class BugReportLoading extends BugReportState {}

final class BugReportLoaded extends BugReportState {}

final class BugReportError extends BugReportState {}
