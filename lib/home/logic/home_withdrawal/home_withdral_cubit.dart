import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_withdral_state.dart';

class HomeWithdralCubit extends Cubit<HomeWithdralState> {
  HomeWithdralCubit() : super(HomeWithdralInitial());
}
