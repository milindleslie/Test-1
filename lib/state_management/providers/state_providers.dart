import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/state_management/states/home_feed_state.dart';

/// File for AppState. All states and their providers will be mentioned here.
final homeFeedStateProvider = StateProvider<HomeFeedState>((ref) {
  return HomeFeedState(banner: null, carouselImages: [], products: []);
});
