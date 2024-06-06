import 'package:bloc/bloc.dart';
import 'package:fms/helper/pengeluaran_database.dart';
import 'package:fms/model/pengeluaran.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_event.dart';
import 'package:fms/pengeluaran/bloc/pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  PengeluaranBloc() : super(PengeluaranInitial()) {
    on<AddPengeluaran>(addPengeluaran);
    on<PengeluaranStart>(pengeluaranStart);
    on<DeletePengeluaran>(deletePengeluaran);
    on<EditPengeluaran>(editPengeluaran);
  }

  Future<void> addPengeluaran(
    AddPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    try {
      int lastId = await PengeluaranDB.addNewPengluaran(event.pengeluaran);
    } catch (e) {
      print(e);
      emit(PengeluaranFailed(message: "Error : $e"));
    } finally {
      emit(PengeluaranPopClose());
    }
  }

  Future<void> pengeluaranStart(
    PengeluaranStart pengeluaranStart,
    Emitter<PengeluaranState> emit,
  ) async {
    emit(PengeluaranLoading());
    List<int> totalPengeluaran = [];
    try {
      List<Pengeluaran> pengeluaranData =
          await PengeluaranDB.getPengeluaranList();
      if (pengeluaranData.length > 0) {
        for (var i in pengeluaranData.map((e) => e.toMap()).toList()) {
          totalPengeluaran.add(i["nominal"]);
        }
      }

      emit(PengeluaranLoaded(
          pengeluaranList: pengeluaranData,
          totalPengeluaran: totalPengeluaran));
    } catch (e) {
      emit(PengeluaranFailed(message: "Error : $e"));
    } finally {
      emit(PengeluaranFinished());
    }
  }

  Future<void> deletePengeluaran(
    DeletePengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    try {
      int datas = await PengeluaranDB.deletePegeluaran(event.id);
    } catch (e) {
      emit(PengeluaranFailed(message: "Error : $e"));
    } finally {
      emit(PengeluaranPopClose());
    }
  }

  Future<void> editPengeluaran(
    EditPengeluaran event,
    Emitter<PengeluaranState> emit,
  ) async {
    try {
      int editId = await PengeluaranDB.updatePengeluaran(
          event.pengeluaran.id!, event.pengeluaran);
    } catch (e) {
      emit(PengeluaranFailed(message: "Error : $e"));
    } finally {
      emit(PengeluaranPopClose());
    }
  }
}
