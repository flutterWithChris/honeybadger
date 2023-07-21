part of 'jobs_bloc.dart';

abstract class JobsEvent extends Equatable {
  const JobsEvent();

  @override
  List<Object> get props => [];
}

class LoadJobs extends JobsEvent {}

class LoadJob extends JobsEvent {
  final String jobId;

  const LoadJob({required this.jobId});

  @override
  List<Object> get props => [jobId];
}

class CreateJob extends JobsEvent {
  final Job job;

  const CreateJob({required this.job});

  @override
  List<Object> get props => [job];
}
