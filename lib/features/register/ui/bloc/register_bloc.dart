// Eventos que recibo
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RegisterEvent {}

class OnRegisterSubmittedEvent extends RegisterEvent {
  final String fullName;
  final String username;
  final String email;
  final String password;

  OnRegisterSubmittedEvent({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });
}

// Estados que emito
abstract class RegisterState {}

class RegisterIdleState extends RegisterState {}

class RegisterLoadingState extends RegisterState {}

class RegisterErrorState extends RegisterState {
  final String errorMessage;
  RegisterErrorState({required this.errorMessage});
}

class RegisterSuccessState extends RegisterState {}

// La clase Bloc

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterIdleState()) {
    on<OnRegisterSubmittedEvent>(register);
  }

  Future<void> register(
    OnRegisterSubmittedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    //Registro, tengo que llamarlo desde un caso de uso
    try {
      //1. Auth
      AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: event.email,
        password: event.password,
      );
      //2. DB
      await Supabase.instance.client.from('profiles').insert({
        'id': response.user?.id,
        'username': event.username,
        'full_name': event.fullName,
        'email': event.email,
      });
      emit(RegisterSuccessState());
    } on Exception catch (e) {
      emit(RegisterErrorState(errorMessage: e.toString()));
    }
  }
}
