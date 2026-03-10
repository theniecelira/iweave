import 'package:flutter/material.dart';

enum StopType { attraction, restaurant, accommodation, weaving }

enum TimeSlot { morning, afternoon, evening }

class AttractionModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String location;
  final double entryFee;
  final double rating;
  final int durationMinutes;
  final List<String> tags;
  final IconData icon;

  const AttractionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.entryFee,
    required this.rating,
    required this.durationMinutes,
    required this.tags,
    required this.icon,
  });
}

class ItineraryStop {
  final String id;
  final StopType type;
  final TimeSlot timeSlot;
  final String itemId;
  final String name;
  final String imageUrl;
  final double cost;
  final String note;
  final IconData icon;

  const ItineraryStop({
    required this.id,
    required this.type,
    required this.timeSlot,
    required this.itemId,
    required this.name,
    required this.imageUrl,
    required this.cost,
    this.note = '',
    required this.icon,
  });

  ItineraryStop copyWith({String? note, TimeSlot? timeSlot}) {
    return ItineraryStop(
      id: id, type: type,
      timeSlot: timeSlot ?? this.timeSlot,
      itemId: itemId, name: name, imageUrl: imageUrl,
      cost: cost, note: note ?? this.note, icon: icon,
    );
  }

  String get typeLabel {
    switch (type) {
      case StopType.attraction: return 'Attraction';
      case StopType.restaurant: return 'Dining';
      case StopType.accommodation: return 'Stay';
      case StopType.weaving: return 'Weaving Workshop';
    }
  }
}

class ItineraryDay {
  final int dayNumber;
  final DateTime date;
  final List<ItineraryStop> stops;

  const ItineraryDay({
    required this.dayNumber,
    required this.date,
    required this.stops,
  });

  ItineraryDay copyWith({List<ItineraryStop>? stops}) {
    return ItineraryDay(dayNumber: dayNumber, date: date, stops: stops ?? this.stops);
  }

  double get totalCost => stops.fold(0.0, (sum, s) => sum + s.cost);
}

class ItineraryModel {
  final String id;
  final String tripName;
  final DateTime startDate;
  final int numberOfDays;
  final List<ItineraryDay> days;
  final int guests;

  const ItineraryModel({
    required this.id,
    required this.tripName,
    required this.startDate,
    required this.numberOfDays,
    required this.days,
    required this.guests,
  });

  ItineraryModel copyWith({
    String? tripName, DateTime? startDate, int? numberOfDays,
    List<ItineraryDay>? days, int? guests,
  }) {
    return ItineraryModel(
      id: id,
      tripName: tripName ?? this.tripName,
      startDate: startDate ?? this.startDate,
      numberOfDays: numberOfDays ?? this.numberOfDays,
      days: days ?? this.days,
      guests: guests ?? this.guests,
    );
  }

  double get totalEstimatedCost => days.fold(0.0, (sum, d) => sum + d.totalCost);
  int get totalStops => days.fold(0, (sum, d) => sum + d.stops.length);
  DateTime get endDate => startDate.add(Duration(days: numberOfDays - 1));
}