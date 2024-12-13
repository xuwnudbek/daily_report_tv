extension Extensions on DateTime {
  String get stringTime => "${hour < 10 ? "0" : ""}$hour:${minute < 10 ? "0" : ""}$minute:${second < 10 ? "0" : ""}$second";
}
