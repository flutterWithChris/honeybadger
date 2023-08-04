import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:honeybadger/core/constants.dart';
import 'package:honeybadger/profile/model/portfolio_project.dart';
import 'package:honeybadger/profile/portfolio/repository/portfiolio_repository.dart';
import 'package:image_picker/image_picker.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository _portfolioRepository;
  PortfolioBloc({
    required PortfolioRepository portfolioRepository,
  })  : _portfolioRepository = portfolioRepository,
        super(PortfolioInitial()) {
    on<LoadPortfolio>((event, emit) async {
      emit(PortfolioLoading());
      try {
        await emit
            .forEach(_portfolioRepository.getPortfolioProjects(event.userId),
                onData: (projects) {
          return PortfolioLoaded(projects: projects);
        });
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text('Error getting portfolio projects!'),
          ),
        );
        print(e);
        emit(PortfolioError(message: e.toString()));
      }
    });
    on<AddProject>((event, emit) async {
      try {
        emit(PortfolioLoading());
        await _portfolioRepository.addPortfolioProject(
            event.userId, event.project, event.images);
        emit(PortfolioUpdated());
        await Future.delayed(const Duration(seconds: 2));
        add(LoadPortfolio(userId: event.userId));
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error adding portfolio project!'),
        ));
        emit(PortfolioError(message: e.toString()));
      }
    });
    on<UpdateProject>((event, emit) async {
      try {
        await _portfolioRepository.updatePortfolioProject(
            event.userId, event.project);
        emit(PortfolioUpdated());
        add(LoadPortfolio(userId: event.userId));
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error updating portfolio project!'),
        ));
        emit(PortfolioError(message: e.toString()));
      }
    });
    on<DeleteProject>((event, emit) async {
      try {
        await _portfolioRepository.deletePortfolioProject(
            event.userId, event.project);
        add(LoadPortfolio(userId: event.userId));
      } catch (e) {
        scaffoldKey.currentState!.showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          content: Text('Error deleting portfolio project!'),
        ));
        emit(PortfolioError(message: e.toString()));
      }
    });
  }
}
