import 'package:fms/model/pemasukkan.dart';

abstract class ListPemasukkanEvent {}

class AddPemasukkan extends ListPemasukkanEvent {
  final Pemasukkan pemasukkan;
  AddPemasukkan({
    required this.pemasukkan,
  });
}

class EditPemasukkan extends ListPemasukkanEvent {
  final Pemasukkan pemasukkan;
  EditPemasukkan({
    required this.pemasukkan,
  });
}

class ListPemasukkanStart extends ListPemasukkanEvent {}

class DeletePemasukkan extends ListPemasukkanEvent {
  final int id;
  DeletePemasukkan({
    required this.id,
  });
}
