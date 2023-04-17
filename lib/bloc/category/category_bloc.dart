import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:passport_unifranz_web/models/category_model.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<CategoryModel> listCategories = [];
  CategoryBloc() : super(const CategoryState()) {
    on<UpdateListCategory>((event, emit) =>
        emit(state.copyWith(existCategories: event.listCategory.isNotEmpty, listCategories: event.listCategory)));

    on<UpdateSortColumnIndexCategory>((event, emit) {
      sort((category) => category.title);
      debugPrint(listCategories.toString());
      emit(state.copyWith(
          listCategories: listCategories, ascending: !state.ascending, sortColumnIndex: event.sortColumnIndex));
    });
    on<AddItemListCategory>((event, emit) =>
        emit(state.copyWith(existCategories: true, listCategories: [...state.listCategories, event.category])));

    on<UpdateItemCategory>(((event, emit) => _onUpdateCategoryById(event, emit)));
  }
  void sort<T>(Comparable<T> Function(CategoryModel category) getField) {
    listCategories = [...state.listCategories];
    listCategories.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      Comparable.compare(aValue, bValue);
      return state.ascending ? Comparable.compare(aValue, bValue) : Comparable.compare(bValue, aValue);
    });
  }

  _onUpdateCategoryById(UpdateItemCategory category, Emitter<CategoryState> emit) async {
    List<CategoryModel> listNewCategory = [...state.listCategories];
    listNewCategory[listNewCategory.indexWhere((e) => e.id == category.category.id)] = category.category;
    emit(state.copyWith(listCategories: listNewCategory));
  }
}
