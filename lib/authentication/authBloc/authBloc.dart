import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterbloc/authentication/authState/authState.dart';
import 'package:flutterbloc/authentication/events/authEvent.dart';

class Authbloc extends Bloc<Authevent, Authstate> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Authbloc() : super(AuthInitial()) {
    on<SignInRequested>(_signIn);
    on<SignupIsRequested>(_signUp);
    on<LogoutIsRequested>(_logOut);
  }

  void _signIn(SignInRequested event, Emitter<Authstate> emit) async{
    emit(AuthLoading());
    try {
       await _auth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(Authenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.code));
    }
  }

  void _signUp(SignupIsRequested event, Emitter<Authstate> emit) async{
    emit(AuthLoading());
    try {
      await  _auth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);
      emit(Authenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.code));
    }
  }

  void _logOut(LogoutIsRequested event, Emitter<Authstate> emit) async {
    emit(AuthLoading());
    try {
      await _auth.signOut();
      emit(UnAuthenticated());
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.code));
    }
  }
}
