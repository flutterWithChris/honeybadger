import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:honeybadger/jobs/model/job.dart';

part 'jobs_event.dart';
part 'jobs_state.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  JobsBloc() : super(JobsInitial()) {
    on<LoadJobs>(_onLoadJobs);
    on<LoadJob>(_onLoadJob);
    on<CreateJob>(_onCreateJob);
  }
  void _onLoadJobs(LoadJobs event, Emitter<JobsState> emit) {
    emit(JobsLoading());
    emit(const JobsLoaded([]));
  }

  void _onLoadJob(LoadJob event, Emitter<JobsState> emit) {
    emit(JobLoading());
    emit(const JobsLoaded([]));
  }

  void _onCreateJob(CreateJob event, Emitter<JobsState> emit) async {
    emit(JobsLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(JobCreated(event.job));
  }
}
