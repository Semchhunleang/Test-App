import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

// =============================== Manufacturer
Widget selectManufacturer(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Manufacturer',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.productBrand.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );
// =============================== product line
Widget selectProductLine(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Product Line',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.tsbProductCateg.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );
// =============================== Engine Model
Widget selectEngineModel(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Engine Model',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.engineModel.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== Component Group
Widget selectComponentGroup(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Component Group',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.componentGroup.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== Model
Widget selectModel(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Model',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.productModel.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== Series
Widget selectSeries(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Series',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.stockProductionLot.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== Type Part
Widget selectTypePart(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Type Part',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          items: viewModel.typePart.toList(),
          itemAsString: (i) => capitalizeFirstLetter(i.value.toString()),
          onChanged: onChanged),
    );

// =============================== Product
Widget selectProduct(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged,
        bool isReadOnly = false}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Product',
          isValidate: validate,
          readOnlyAndFilled: isReadOnly,
          enabled: !isReadOnly,
          selected: selected,
          isSearch: true,
          items: viewModel.product.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );
