import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/provider/app_state.dart';
import 'package:provider/provider.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;

  const CategoryWidget({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedCategoryId == category.id;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState.updateCategoryId(category.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.white : const Color(0x99FFFFFF), width: 3),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            category.icon == 'todos'
                ? Icon(
                    Icons.search,
                    color: isSelected ? const Color(0xffF26522) : Colors.white,
                    size: 40,
                  )
                : SvgPicture.network(
                    category.icon,
                    colorFilter: ColorFilter.mode(isSelected ? const Color(0xffF26522) : Colors.white, BlendMode.srcIn),
                    height: 40,
                  ),
            const SizedBox(
              height: 10,
            ),
            Text(
              category.title,
              style: TextStyle(color: isSelected ? const Color(0xffF26522) : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
