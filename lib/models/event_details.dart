class EventDetailsResponse {
  List<EventDetails> eventDetails;

  EventDetailsResponse({this.eventDetails});

  EventDetailsResponse.fromJson(Map<String, dynamic> json) {
    if (json['eventDetails'] != null) {
      eventDetails = new List<EventDetails>();
      json['eventDetails'].forEach((v) {
        eventDetails.add(new EventDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.eventDetails != null) {
      data['eventDetails'] = this.eventDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventDetails {
  String name;
  String dateTime;
  String bookBy;
  int ticketsSold;
  int maxTickets;
  int friendsAttending;
  double price;
  bool isPartnered;
  String sport;
  int totalPrize;
  String location;
  String description;
  String venueInformation;
  String eventCreator;
  String teamInformation;
  String tags;
  String mainImage;
  int id;

  EventDetails(
      {this.name,
      this.dateTime,
      this.bookBy,
      this.ticketsSold,
      this.maxTickets,
      this.friendsAttending,
      this.price,
      this.isPartnered,
      this.sport,
      this.totalPrize,
      this.location,
      this.description,
      this.venueInformation,
      this.eventCreator,
      this.teamInformation,
      this.tags,
      this.mainImage,
      this.id});

  EventDetails.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    dateTime = json['dateTime'];
    bookBy = json['bookBy'];
    ticketsSold = json['ticketsSold'];
    maxTickets = json['maxTickets'];
    friendsAttending = json['friendsAttending'];
    price = json['price'].toDouble();
    isPartnered = json['isPartnered'];
    sport = json['sport'];
    totalPrize = json['totalPrize'];
    location = json['location'];
    description = json['description'];
    venueInformation = json['venueInformation'];
    eventCreator = json['eventCreator'];
    teamInformation = json['teamInformation'];
    tags = json['tags'];
    mainImage = json['mainImage'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['dateTime'] = this.dateTime;
    data['bookBy'] = this.bookBy;
    data['ticketsSold'] = this.ticketsSold;
    data['maxTickets'] = this.maxTickets;
    data['friendsAttending'] = this.friendsAttending;
    data['price'] = this.price;
    data['isPartnered'] = this.isPartnered;
    data['sport'] = this.sport;
    data['totalPrize'] = this.totalPrize;
    data['location'] = this.location;
    data['description'] = this.description;
    data['venueInformation'] = this.venueInformation;
    data['eventCreator'] = this.eventCreator;
    data['teamInformation'] = this.teamInformation;
    data['tags'] = this.tags;
    data['mainImage'] = this.mainImage;
    data['id'] = this.id;
    return data;
  }
}
