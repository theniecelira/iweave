import 'package:flutter/material.dart';
import '../models/itinerary_model.dart';

class ItineraryProvider extends ChangeNotifier {
  ItineraryModel? _current;
  int _currentStep = 0;

  ItineraryModel? get current => _current;
  int get currentStep => _currentStep;

  void startNewItinerary({
    required String tripName,
    required DateTime startDate,
    required int numberOfDays,
    required int guests,
  }) {
    final days = List.generate(numberOfDays, (i) => ItineraryDay(
      dayNumber: i + 1,
      date: startDate.add(Duration(days: i)),
      stops: [],
    ));
    _current = ItineraryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      tripName: tripName,
      startDate: startDate,
      numberOfDays: numberOfDays,
      days: days,
      guests: guests,
    );
    _currentStep = 1;
    notifyListeners();
  }

  void setStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  void addStop({required int dayIndex, required ItineraryStop stop}) {
    if (_current == null) return;
    final days = List<ItineraryDay>.from(_current!.days);
    final day = days[dayIndex];
    final stops = List<ItineraryStop>.from(day.stops)..add(stop);
    days[dayIndex] = day.copyWith(stops: stops);
    _current = _current!.copyWith(days: days);
    notifyListeners();
  }

  void removeStop({required int dayIndex, required String stopId}) {
    if (_current == null) return;
    final days = List<ItineraryDay>.from(_current!.days);
    final day = days[dayIndex];
    final stops = day.stops.where((s) => s.id != stopId).toList();
    days[dayIndex] = day.copyWith(stops: stops);
    _current = _current!.copyWith(days: days);
    notifyListeners();
  }

  void updateStopNote({required int dayIndex, required String stopId, required String note}) {
    if (_current == null) return;
    final days = List<ItineraryDay>.from(_current!.days);
    final day = days[dayIndex];
    final stops = day.stops.map((s) => s.id == stopId ? s.copyWith(note: note) : s).toList();
    days[dayIndex] = day.copyWith(stops: stops);
    _current = _current!.copyWith(days: days);
    notifyListeners();
  }

  bool isStopAdded(String itemId, int dayIndex) {
    if (_current == null) return false;
    return _current!.days[dayIndex].stops.any((s) => s.itemId == itemId);
  }

  void reset() {
    _current = null;
    _currentStep = 0;
    notifyListeners();
  }

  ItineraryModel? confirm() {
    final result = _current;
    _current = null;
    _currentStep = 0;
    notifyListeners();
    return result;
  }
}