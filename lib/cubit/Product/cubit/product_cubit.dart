import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import 'package:map_bloc_crud/Model/ProductModel.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final Dio _dio = Dio();
  final String _url = 'https://64b77bdb21b9aa6eb07829ab.mockapi.io/product';

  ProductCubit() : super(ProductInitial());

  Future<void> fetchProducts() async {
    emit(ProductLoading());
    try {
      final response = await _dio.get(_url);
      final List<dynamic> data = response.data;
      final products = data.map((json) => Product.fromJson(json)).toList();
      emit(ProductLoaded(products));
    } catch (error) {
      emit(ProductError('Failed to fetch products: ${error.toString()}'));
    }
  }
}
