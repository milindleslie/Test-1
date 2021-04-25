import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/state_management/states/events_state.dart';

/// File for AppState. All states and their providers will be mentioned here.
final allEventsStateProvider = StateProvider<AllEventsState>((ref) {
  return AllEventsState(allEvents: []);
});

final eventDetailsProvider = StateProvider<EventDetailsState>((ref) {
  return EventDetailsState(eventDetails: [], selectedEventDetail: null);
});
