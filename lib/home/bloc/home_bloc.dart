import 'package:bloc/bloc.dart';
import 'package:fms/helper/pemasukkan_database.dart';
import 'package:fms/helper/pengeluaran_database.dart';
import 'package:fms/home/bloc/home_event.dart';
import 'package:fms/home/bloc/home_state.dart';
import 'package:fms/model/pemasukkan.dart';
import 'package:fms/model/pengeluaran.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeStart>(homeStart);
  }

  Future<void> homeStart(
    HomeStart event,
    Emitter<HomeState> emit,
  ) async {
    try {
      List<int> totalPemasukan = [];
      List<int> totalPengeluaran = [];
      List<Pemasukkan> pemasukkan = await PemasukkanDB.getPemasukkanList();
      if (pemasukkan.length > 0) {
        for (var i in pemasukkan.map((e) => e.toMap()).toList()) {
          totalPemasukan.add(i['nominal']);
        }
      }

      List<Pengeluaran> pengeluaran = await PengeluaranDB.getPengeluaranList();

      if (pengeluaran.length > 0) {
        for (var i in pengeluaran.map((e) => e.toMap()).toList()) {
          totalPengeluaran.add(i['nominal']);
        }
      }

      print("HomeStart");
      print(totalPemasukan);
      print(totalPengeluaran);

      emit(HomeLoaded(
        totalPemasukan: totalPemasukan,
        totalPengeluaran: totalPengeluaran,
      ));
    } catch (e) {
      emit(HomeFailed(message: "Error : $e"));
    } finally {
      emit(HomeFinished());
    }
  }
}
