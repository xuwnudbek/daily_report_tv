import 'dart:async';

import 'package:daily_report_tv/services/http_service.dart';
import 'package:daily_report_tv/services/storage_service.dart';
import 'package:daily_report_tv/utils/extensions.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  set selectedDate(value) {
    _selectedDate = value;
    notifyListeners();
  }

  List _reports = [];
  List get reports => _reports;
  set reports(List value) {
    _reports = value;
    notifyListeners();
  }

  String _time = "00:00:00";
  String get time => _time;
  set time(value) {
    _time = value;
    notifyListeners();
  }

  Timer? timer;

  Offset _offset = const Offset(0, 0);
  Offset get offset => _offset;
  set offset(value) {
    _offset = value;
    notifyListeners();
  }

  String _selectedAforizm = "";
  String get selectedAforizm => _selectedAforizm;
  set selectedAforizm(value) {
    _selectedAforizm = value;
    notifyListeners();
  }

  List<String> aforizmlar = [
    "Buyuk natijalarga birgalikda erishamiz",
    "Maqsadga birgalikda erishamiz",
    "Rejalashtirish – ishda muvaffaqiyatning siri",
    "Bugungi yaxshidan ertangi mukammal sari",
    "Yaxshilik yo'lida birlashamiz",
  ];

  DateTime? _updatedAt = StorageService.readData('updatedAt');
  DateTime? get updatedAt => _updatedAt;
  set updatedAt(value) {
    _updatedAt = value;
    notifyListeners();
  }

  MainProvider() {
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      time = DateTime.now().stringTime;
    });

    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (selectedAforizm.isEmpty || selectedAforizm == aforizmlar.last) {
        selectedAforizm = aforizmlar.first;
      } else {
        selectedAforizm = aforizmlar.elementAt(aforizmlar.indexOf(selectedAforizm) + 1);
      }
    });

    Timer.periodic(const Duration(minutes: 5), (_) async {
      await getReports(startTime: selectedDate ?? DateTime.now(), withLoad: false);
    });

    initialize();
  }

  Future<void> initialize() async {
    await getReports(startTime: selectedDate ?? DateTime.now());
  }

  Future<void> getReports({
    DateTime? startTime,
    DateTime? endTime,
    bool withLoad = true,
  }) async {
    if (withLoad) {
      isLoading = true;
    }

    final res = await HttpService.get(patokanalytics, params: {
      'start_date': startTime?.toIso8601String().split("T").first,
    });

    if (res['status'] == Result.success) {
      reports = res['data'];
    }

    updatedAt = DateTime.now();

    if (withLoad) {
      isLoading = false;
    }
  }

  List sortPatoks(List patoks) {
    patoks.sort((a, b) {
      int diffA = a['products']?.first?['real_ish'] ?? 0 - int.parse((a['products'].first['kutilayotgan'] as double).toStringAsFixed(0)) ?? 0;
      int diffB = b['products']?.first?['real_ish'] ?? 0 - b['products']?.first?['kutilayotgan'] ?? 0;

      // diffA or diffB may be negative number
      return diffB.compareTo(diffA);
    });

    return patoks;
  }

  String calcPercentage(int a, int b) {
    double perc = ((b - a) * 100 / a);

    return " ${perc > 0 ? "+" : ""}${perc.toStringAsFixed(1)}% ${perc > 0 ? "⬆️" : perc < 0 ? "⬇️" : ""}";
  }
}
