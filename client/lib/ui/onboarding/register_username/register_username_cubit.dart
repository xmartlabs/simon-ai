import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_username_cubit.freezed.dart';
part 'register_username_state.dart';

class RegisterUsernameCubit extends Cubit<RegisterUsernameState> {
  RegisterUsernameCubit()
      : super(
          const RegisterUsernameState.initial(username: ''),
        );
}
