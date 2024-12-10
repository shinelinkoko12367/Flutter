import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_bloc_crud/Model/UserModel.dart';
import 'package:http/http.dart' as http;
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataInitial()) {
    on<FetchData>(_onFetchData);
    on<CreateData>(_onCreateData);
    on<UpdateData>(_onUpdateData);
    on<DeleteData>(_onDeleteData);
  }

  Future<void> _onFetchData(FetchData event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final response = await http
          .get(Uri.parse('https://64b77bdb21b9aa6eb07829ab.mockapi.io/api'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        // Map the JSON response to a list of User objects
        final List<User> users =
            data.map((json) => User.fromJson(json)).toList();
        emit(DataLoaded(users));
      } else {
        emit(DataError('Failed to load data'));
      }
    } catch (e) {
      emit(DataError('An error occurred: $e'));
    }
  }

  // Create data
  Future<void> _onCreateData(CreateData event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final response = await http.post(
        Uri.parse('https://64b77bdb21b9aa6eb07829ab.mockapi.io/api'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"title": event.user.title, "desc": event.user.desc}),
      );
      log(json.encode(event.user.toJson()).toString());
      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        final user = User.fromJson(data);
        emit(DataCreated(user));
      } else {
        emit(DataError('Failed to create data'));
      }
    } catch (e) {
      emit(DataError('An error occurred: $e'));
    }
  }

  Future<void> _onUpdateData(UpdateData event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      log(event.user.toJson().toString());
      final response = await http.put(
        Uri.parse(
            'https://64b77bdb21b9aa6eb07829ab.mockapi.io/api/${event.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "title": event.user.title,
          "desc": event.user.desc,
        }),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = User.fromJson(data);
        emit(DataUpdated(user));
      } else {
        emit(DataError('Failed to update data'));
      }
    } catch (e) {
      emit(DataError('An error occurred: $e'));
    }
  }

  // Delete data
  Future<void> _onDeleteData(DeleteData event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      final response = await http.delete(
        Uri.parse(
            'https://64b77bdb21b9aa6eb07829ab.mockapi.io/api/${event.id}'),
      );
      if (response.statusCode == 200) {
        emit(DataDeleted());
      } else {
        emit(DataError('Failed to delete data'));
      }
    } catch (e) {
      emit(DataError('An error occurred: $e'));
    }
  }
}
