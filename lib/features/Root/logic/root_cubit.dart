

    import 'package:flutter_bloc/flutter_bloc.dart';

class RootCubit extends Cubit<int>{ // int mean the state for screen
  RootCubit(): super(0); // 0 mean the first value for state
    void changeScreen(int index){
     emit(index);
   }
}
