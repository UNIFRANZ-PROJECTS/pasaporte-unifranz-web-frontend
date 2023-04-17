import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:passport_unifranz_web/bloc/category/category_bloc.dart';
import 'package:passport_unifranz_web/components/compoents.dart';
import 'package:passport_unifranz_web/services/cafe_api.dart';
import 'package:passport_unifranz_web/views/client/headers.dart';
import 'package:passport_unifranz_web/models/category_model.dart';
import 'package:passport_unifranz_web/services/services.dart';

class AddCategoryForm extends StatefulWidget {
  final String titleheader;
  final CategoryModel? item;
  const AddCategoryForm({super.key, this.item, required this.titleheader});

  @override
  State<AddCategoryForm> createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController titleCtrl = TextEditingController();
  String? imageFile;
  Uint8List? bytes;
  bool stateLoading = false;
  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      setState(() {
        titleCtrl = TextEditingController(text: widget.item!.title);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
            key: formKey,
            child: SingleChildScrollView(
                child: Column(children: [
              HedersComponent(
                title: widget.titleheader,
                initPage: false,
              ),
              (size.width > 1000)
                  ? Row(children: [for (final item in inputs()) Expanded(child: item)])
                  : Column(children: inputs()),
              !stateLoading
                  ? widget.item == null
                      ? ButtonComponent(text: 'Crear Categoria', onPressed: () => createCategory())
                      : ButtonComponent(text: 'Actualizar Categoria', onPressed: () => updateCategory())
                  : Center(
                      child: Image.asset(
                      'assets/gifs/load.gif',
                      fit: BoxFit.cover,
                      height: 20,
                    ))
            ]))));
  }

  List<Widget> inputs() {
    return [
      SvgInputComponent(
        defect: widget.item == null ? null : widget.item!.icon,
        onPressed: (imageBytes) => setState(() => bytes = imageBytes),
      ),
      InputComponent(
          textInputAction: TextInputAction.done,
          controllerText: titleCtrl,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z ]")),
            LengthLimitingTextInputFormatter(100)
          ],
          onEditingComplete: () {},
          validator: (value) {
            if (value.isNotEmpty) {
              return null;
            } else {
              return 'complemento';
            }
          },
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          labelText: "Titulo:",
          hintText: "Titulo del evento"),
    ];
  }

  createCategory() async {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'title': titleCtrl.text.trim(),
      'archivo': MultipartFile.fromBytes(bytes!),
    });
    return CafeApi.post(categories(null), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final category = categoryItemModelFromJson(json.encode(res.data['categoria']));
      categoryBloc.add(AddItemListCategory(category));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }

  updateCategory() {
    final categoryBloc = BlocProvider.of<CategoryBloc>(context, listen: false);
    CafeApi.configureDio();
    FocusScope.of(context).unfocus();
    if (!formKey.currentState!.validate()) return;
    setState(() => stateLoading = !stateLoading);
    FormData formData = FormData.fromMap({
      'title': titleCtrl.text.trim(),
      'archivo': bytes != null ? MultipartFile.fromBytes(bytes!) : null,
    });
    return CafeApi.put(categories(widget.item!.id), formData).then((res) async {
      setState(() => stateLoading = !stateLoading);
      final categoryEdit = categoryItemModelFromJson(json.encode(res.data['categoria']));
      categoryBloc.add(UpdateItemCategory(categoryEdit));
      Navigator.pop(context);
    }).catchError((e) {
      setState(() => stateLoading = !stateLoading);
      debugPrint('error en en : ${e.response.data['errors'][0]['msg']}');
      callDialogAction(context, '${e.response.data['errors'][0]['msg']}');
    });
  }
}
