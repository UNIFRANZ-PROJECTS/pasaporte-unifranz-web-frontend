part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final bool existCategories;
  final List<CategoryModel> listCategories;

  final bool isLoading;
  final bool ascending;
  final int? sortColumnIndex;
  const CategoryState(
      {this.existCategories = false,
      this.listCategories = const [],
      this.isLoading = true,
      this.ascending = true,
      this.sortColumnIndex});

  CategoryState copyWith({
    bool? existCategories,
    List<CategoryModel>? listCategories,
    bool? isLoading,
    bool? ascending,
    int? sortColumnIndex,
  }) =>
      CategoryState(
          existCategories: existCategories ?? this.existCategories,
          listCategories: listCategories ?? this.listCategories,
          isLoading: isLoading ?? this.isLoading,
          ascending: ascending ?? this.ascending,
          sortColumnIndex: sortColumnIndex ?? this.sortColumnIndex);

  @override
  List<Object> get props => [existCategories, listCategories];
}
