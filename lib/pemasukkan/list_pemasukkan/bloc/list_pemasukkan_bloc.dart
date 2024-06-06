import 'package:bloc/bloc.dart';
import 'package:fms/helper/pemasukkan_database.dart';
import 'package:fms/model/pemasukkan.dart';
import 'package:fms/pemasukkan/list_pemasukkan/bloc/list_pemasukkan_event.dart';
import 'package:fms/pemasukkan/list_pemasukkan/bloc/list_pemasukkan_state.dart';

class ListPemasukkanBloc
    extends Bloc<ListPemasukkanEvent, ListPemasukkanState> {
  ListPemasukkanBloc() : super(ListPemasukkanInitial()) {
    on<ListPemasukkanStart>(listPemasukkanStart);
    on<AddPemasukkan>(addPemasukkan);
    on<DeletePemasukkan>(deletePemasukkan);
    on<EditPemasukkan>(editPemasukkan);
  }

  Future<void> addPemasukkan(
    AddPemasukkan event,
    Emitter<ListPemasukkanState> emit,
  ) async {
    emit(ListPemasukkanLoading());
    try {
      print(event.pemasukkan.keterangan);
      int lastId = await PemasukkanDB.addNewPemasukkan(event.pemasukkan);
      print(lastId);
    } catch (e) {
      print(e);
      emit(ListPemasukkanFailed(message: "Error: ${e}"));
    } finally {
      emit(ListPemasukkanPopClose());
    }
  }

  Future<void> listPemasukkanStart(
    ListPemasukkanStart event,
    Emitter<ListPemasukkanState> emit,
  ) async {
    emit(ListPemasukkanLoading());
    List<int> totalPemasukkan = [];
    try {
      List<Pemasukkan> pemasukkan = await PemasukkanDB.getPemasukkanList();
      print('object');
      print(pemasukkan.length);

      if (pemasukkan.length > 0) {
        for (var i in pemasukkan.map((e) => e.toMap()).toList()) {
          totalPemasukkan.add(i['nominal']);
        }
      }

      emit(ListPemasukkanLoaded(
        pemasukkan: pemasukkan,
        totalPemasukkan: totalPemasukkan,
      ));
    } catch (e) {
      print(e);
      emit(ListPemasukkanFailed(message: "Erro : $e"));
    } finally {
      emit(ListPemasukkanFinished());
    }
  }

  Future<void> deletePemasukkan(
    DeletePemasukkan event,
    Emitter<ListPemasukkanState> emit,
  ) async {
    emit(ListPemasukkanLoading());
    try {
      int deleteId = await PemasukkanDB.deletePemasukkan(event.id);
    } catch (e) {
      emit(ListPemasukkanFailed(message: "Error: ${e}"));
    } finally {
      emit(ListPemasukkanPopClose());
    }
  }

  Future<void> editPemasukkan(
    EditPemasukkan event,
    Emitter<ListPemasukkanState> emit,
  ) async {
    emit(ListPemasukkanLoading());
    try {
      int editedId = await PemasukkanDB.updatePemasukkan(
          event.pemasukkan.id!, event.pemasukkan);
    } catch (e) {
      print(e);
      emit(ListPemasukkanFailed(message: "Error: ${e}"));
    } finally {
      emit(ListPemasukkanPopClose());
    }
  }
}
