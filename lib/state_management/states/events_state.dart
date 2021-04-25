import 'package:test_app/models/all_events.dart';
import 'package:test_app/models/event_details.dart';

enum ViewState { idle, fetching, busy, error }

class AllEventsState {
  List<AllEvents> allEvents;

  AllEventsState({
    this.allEvents,
  });

  AllEventsState copyWith({
    List<AllEvents> allEvents,
  }) {
    return new AllEventsState(
      allEvents: allEvents ?? this.allEvents,
    );
  }
}

class EventDetailsState {
  List<EventDetails> eventDetails;
  EventDetails selectedEventDetail;

  EventDetailsState({
    this.eventDetails,
    this.selectedEventDetail,
  });

  EventDetailsState copyWith({
    List<EventDetails> eventDetails,
    EventDetails selectedEventDetail,
  }) {
    return new EventDetailsState(
      eventDetails: eventDetails ?? this.eventDetails,
      selectedEventDetail: selectedEventDetail ?? this.selectedEventDetail,
    );
  }
}

class ScreenState {
  ViewState viewState;
  ScreenState({this.viewState});

  ScreenState copyWith({
    ViewState viewState,
  }) {
    return new ScreenState(
      viewState: viewState ?? this.viewState,
    );
  }
}
