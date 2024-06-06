import 'package:fms/model/pengeluaran.dart';

abstract class PengeluaranState {}

class PengeluaranInitial extends PengeluaranState {}

class PengeluaranLoading extends PengeluaranState {}

class PengeluaranLoaded extends PengeluaranState {
  final List<Pengeluaran> pengeluaranList;
  final List<int> totalPengeluaran;

  PengeluaranLoaded({
    required this.pengeluaranList,
    required this.totalPengeluaran,
  });
}

class PengeluaranFailed extends PengeluaranState {
  String message;

  PengeluaranFailed({
    required this.message,
  });
}

class PengeluaranFinished extends PengeluaranState {}

class PengeluaranPopClose extends PengeluaranState {}
