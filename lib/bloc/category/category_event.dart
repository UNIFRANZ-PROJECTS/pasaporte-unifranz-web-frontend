part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class UpdateListCategory extends CategoryEvent {
  final List<CategoryModel> listCategory;

  const UpdateListCategory(this.listCategory);
}

class UpdateSortColumnIndexCategory extends CategoryEvent {
  final int sortColumnIndex;

  const UpdateSortColumnIndexCategory(this.sortColumnIndex);
}

class AddItemListCategory extends CategoryEvent {
  final CategoryModel category;

  const AddItemListCategory(this.category);
}

class UpdateItemCategory extends CategoryEvent {
  final CategoryModel category;
  const UpdateItemCategory(this.category);
}
