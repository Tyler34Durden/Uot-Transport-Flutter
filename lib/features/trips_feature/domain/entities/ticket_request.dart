class TicketRequest {
  const TicketRequest({
    required this.tripID,
    required this.fromTripRoute,
    required this.toTripRoute,
  });

  final int tripID;
  final int fromTripRoute;
  final int toTripRoute;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'tripID': tripID,
        'fromTripRoute': fromTripRoute,
        'toTripRoute': toTripRoute,
      };
}

