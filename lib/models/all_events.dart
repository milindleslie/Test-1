class AllEventsResponse {
  List<AllEvents> allEvents;

  AllEventsResponse({this.allEvents});

  AllEventsResponse.fromJson(Map<String, dynamic> json) {
    if (json['allEvents'] != null) {
      allEvents = new List<AllEvents>();
      json['allEvents'].forEach((v) {
        allEvents.add(new AllEvents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allEvents != null) {
      data['allEvents'] = this.allEvents.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllEvents {
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
  bool isRecommended;
  String mainImage;
  int id;

  AllEvents(
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
      this.isRecommended,
      this.mainImage,
      this.id});

  AllEvents.fromJson(Map<String, dynamic> json) {
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
    isRecommended = json['isRecommended'];
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
    data['isRecommended'] = this.isRecommended;
    data['mainImage'] = this.mainImage;
    data['id'] = this.id;
    return data;
  }
}
