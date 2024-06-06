import 'package:fms/model/pemasukkan.dart';

abstract class ListPemasukkanState {}

class ListPemasukkanInitial extends ListPemasukkanState {}

class ListPemasukkanLoading extends ListPemasukkanState {}

class ListPemasukkanLoaded extends ListPemasukkanState {
  final List<Pemasukkan> pemasukkan;

  final List<int> totalPemasukkan;

  ListPemasukkanLoaded({
    required this.pemasukkan,
    required this.totalPemasukkan,
  });
}

class ListPemasukkanFailed extends ListPemasukkanState {
  String message;

  ListPemasukkanFailed({
    required this.message,
  });
}

class ListPemasukkanFinished extends ListPemasukkanState {}

class ListPemasukkanPopClose extends ListPemasukkanState {}
