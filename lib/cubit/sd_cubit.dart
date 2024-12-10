import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sd_state.dart';

class SdCubit extends Cubit<SdState> {
  SdCubit() : super(SdInitial());
}
