abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<int> totalPemasukan;
  final List<int> totalPengeluaran;

  HomeLoaded({
    required this.totalPemasukan,
    required this.totalPengeluaran,
  });
}

class HomeFailed extends HomeState {
  final String message;

  HomeFailed({
    required this.message,
  });
}

class HomeFinished extends HomeState {}
