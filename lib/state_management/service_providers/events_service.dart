import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test_app/models/all_events.dart';
import 'package:test_app/models/event_details.dart';
import 'package:test_app/state_management/states/events_state.dart';

import '../../network/network.dart';
import '../providers/state_providers.dart';

class EventsService extends StateNotifier<ScreenState> {
  final Reader read;

  EventsService(this.read) : super(ScreenState(viewState: ViewState.fetching));

  Future getAllEvents({bool initialLoad, Function(bool result, String error) completion}) async {
    /// Setting screen state
    state = state.copyWith(viewState: initialLoad ? ViewState.fetching : ViewState.busy);

    try {
      /// Network call
      Response response = await NetworkAdapter.shared.post(endPoint: EndPoint.allEvents);
      AllEventsResponse parsedResponse = AllEventsResponse.fromJson(response.data);

      /// Updating state
      var provider = read(allEventsStateProvider);
      provider.state = provider.state.copyWith(allEvents: parsedResponse.allEvents);

      completion(true, 'Success');
      state = state.copyWith(viewState: ViewState.idle);
    } catch (error) {
      completion(false, error.toString());
      state = state.copyWith(viewState: ViewState.error);
    }
  }

  Future getEventDetails({bool initialLoad, int id, Function(bool result, String error) completion}) async {
    /// Setting screen state
    state = state.copyWith(viewState: initialLoad ? ViewState.fetching : ViewState.busy);

    try {
      /// Network call
      Response response = await NetworkAdapter.shared.post(endPoint: EndPoint.eventDetails);
      EventDetailsResponse parsedResponse = EventDetailsResponse.fromJson(response.data);

      EventDetails eventDetails = parsedResponse.eventDetails.firstWhere((element) => element.id == id);

      /// Updating state
      var provider = read(eventDetailsProvider);
      provider.state = provider.state.copyWith(eventDetails: parsedResponse.eventDetails, selectedEventDetail: eventDetails);

      completion(true, 'Success');
      state = state.copyWith(viewState: ViewState.idle);
    } catch (error) {
      completion(false, error.toString());
      state = state.copyWith(viewState: ViewState.error);
    }
  }
}
