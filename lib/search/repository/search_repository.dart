import 'dart:async';

import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SearchRepository {
  final HitsSearcher hitsSearcher = HitsSearcher(
    applicationID: dotenv.env['ALGOLIA_APP_ID']!,
    apiKey: dotenv.env['ALGOLIA_API_KEY']!,
    indexName: 'projects',
  );

  void setQuery(String query) async {
    hitsSearcher.applyState((state) => state.copyWith(query: query, page: 0));
  }

  Stream<SearchState> getSearchState() {
    return hitsSearcher.state;
  }

  Stream<SearchResponse> getSearchResults() {
    return hitsSearcher.responses;
  }

  void loadMore() async {
    hitsSearcher.applyState((state) => state.copyWith(page: state.page! + 1));
  }

  void clear() async {
    hitsSearcher.applyState((state) => state.copyWith(query: ''));
  }

  void dispose() {
    hitsSearcher.dispose();
  }
}
