import 'package:fms/model/pengeluaran.dart';

abstract class PengeluaranEvent {}

class AddPengeluaran extends PengeluaranEvent {
  final Pengeluaran pengeluaran;

  AddPengeluaran({
    required this.pengeluaran,
  });
}

class PengeluaranStart extends PengeluaranEvent {}

class DeletePengeluaran extends PengeluaranEvent {
  int id;
  DeletePengeluaran({
    required this.id,
  });
}

class EditPengeluaran extends PengeluaranEvent {
  final Pengeluaran pengeluaran;

  EditPengeluaran({
    required this.pengeluaran,
  });
}
