part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent {}
class OnDeactivateManualMarkerEvent extends SearchEvent {}


class OnNewPlacesFoundEvent extends SearchEvent{
  //final List<Feature> places;
  final List<Candidate> places;
  
  const OnNewPlacesFoundEvent(this.places);
}

class AddToHistoryEvent extends SearchEvent {
  
  //final Feature place;
  final Candidate place;
  const AddToHistoryEvent(this.place);
}

