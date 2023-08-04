import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchRepository {
  final HitsSearcher hitsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_API_KEY']!,
    indexName: 'projects',
  );

  final HitsSearcher categoryHitsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_API_KEY']!,
    indexName: 'categories',
  );
  final HitsSearcher skillsHitsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_API_KEY']!,
    indexName: 'skills',
    debounce: const Duration(milliseconds: 500),
  );

  void setQuery(String query, String indexName) async {
    switch (indexName) {
      case 'projects':
        hitsSearcher
            .applyState((state) => state.copyWith(query: query, page: 0));
        break;
      case 'categories':
        categoryHitsSearcher
            .applyState((state) => state.copyWith(query: query, page: 0));
        break;
      case 'skills':
        skillsHitsSearcher
            .applyState((state) => state.copyWith(query: query, page: 0));
        break;
      default:
        hitsSearcher
            .applyState((state) => state.copyWith(query: query, page: 0));
        break;
    }
  }

  Stream<SearchState> getSearchState(String index) {
    switch (index) {
      case 'projects':
        return hitsSearcher.state;
      case 'categories':
        return categoryHitsSearcher.state;
      case 'skills':
        return skillsHitsSearcher.state;
      default:
        return hitsSearcher.state;
    }
  }

  Stream<SearchResponse> getSearchResults(String indexName) {
    switch (indexName) {
      case 'projects':
        return hitsSearcher.responses;
      case 'categories':
        return categoryHitsSearcher.responses;
      case 'skills':
        return skillsHitsSearcher.responses;
      default:
        return hitsSearcher.responses;
    }
  }

  void loadMore(String index) async {
    switch (index) {
      case 'projects':
        hitsSearcher
            .applyState((state) => state.copyWith(page: state.page! + 1));
        break;
      case 'categories':
        categoryHitsSearcher
            .applyState((state) => state.copyWith(page: state.page! + 1));
        break;
      case 'skills':
        skillsHitsSearcher
            .applyState((state) => state.copyWith(page: state.page! + 1));
      default:
        hitsSearcher
            .applyState((state) => state.copyWith(page: state.page! + 1));
        break;
    }
  }

  void clear(String index) async {
    switch (index) {
      case 'projects':
        hitsSearcher.applyState((state) => state.copyWith(query: ''));
        break;
      case 'categories':
        categoryHitsSearcher.applyState((state) => state.copyWith(query: ''));
        break;
      case 'skills':
        skillsHitsSearcher.applyState((state) => state.copyWith(query: ''));
        break;
      default:
        hitsSearcher.applyState((state) => state.copyWith(query: ''));
        break;
    }
  }

  // Search Categories
  Future<SearchResponse> searchCategories(String query) async {
    categoryHitsSearcher.applyState((state) => state.copyWith(query: query));
    return categoryHitsSearcher.responses.first;
  }

  void dispose() {
    categoryHitsSearcher.dispose();
    hitsSearcher.dispose();
  }
}
