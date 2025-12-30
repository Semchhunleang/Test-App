// =============================== STATUS
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

Widget filterSelectStatus(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => Expanded(
            child: CustomDropList(
                selected: viewModel.statusVehicleCheck[selected],
                items: viewModel.statusVehicleCheck.values.toList(),
                itemAsString: (i) => i.toString(),
                onChanged: (v) {
                  final selectedKey = viewModel.statusVehicleCheck.entries
                      .firstWhere((entry) => entry.value == v)
                      .key;
                  onValue(selectedKey);
                }),),);

Widget filterSelectPeople(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => Expanded(
            child: CustomDropList(
                selected: viewModel.peopleVehicleCheck[selected],
                items: viewModel.peopleVehicleCheck.values.toList(),
                itemAsString: (i) => i.toString(),
                onChanged: (v) {
                  final selectedKey = viewModel.peopleVehicleCheck.entries
                      .firstWhere((entry) => entry.value == v)
                      .key;
                  onValue(selectedKey);
                }),),);

Widget selectEmployees(
        {required dynamic selected,
        String? titleHead,
        required dynamic Function(dynamic) onChanged,
        required bool enabled,
        required bool readOnlyAndFilled}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => CustomDropList(
            enabled: enabled,
            readOnlyAndFilled: readOnlyAndFilled,
            titleHead: titleHead,
            selected: selected,
            items: viewModel.employees.toList(),
            itemAsString: (i) => i.name.toString(),
            isSearch: true,
            onChanged: onChanged),);

Widget checkTypeSelection(
        {required String selected,
        required Function(String) onValue,
        required bool isValidate,
        required bool enabled,
        required bool readOnlyAndFilled}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => CustomDropList(
            enabled: enabled,
            readOnlyAndFilled: readOnlyAndFilled,
            isValidate: isValidate,
            titleHead: "Check Type",
            selected: viewModel.checkType[selected],
            items: viewModel.checkType.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.checkType.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),);

Widget selectFleetVehicle(
        {required dynamic selected,
        String? titleHead,
        required dynamic Function(dynamic) onChanged,
        required bool isValidate,
        required bool enabled,
        required bool readOnlyAndFilled}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => CustomDropList(
            enabled: enabled,
            readOnlyAndFilled: readOnlyAndFilled,
            isValidate: isValidate,
            titleHead: titleHead,
            selected: selected,
            items: viewModel.fleetVehicle.toList(),
            itemAsString: (i) => i.name.toString(),
            isSearch: true,
            onChanged: onChanged),);

Widget selectState(
        {required dynamic selected,
        String? titleHead,
        required dynamic Function(dynamic) onChanged,
        required bool enabled,
        required bool readOnlyAndFilled}) =>
    Consumer<SelectionsViewModel>(
        builder: (context, viewModel, _) => CustomDropList(
            enabled: enabled,
            readOnlyAndFilled: readOnlyAndFilled,
            titleHead: titleHead,
            selected: selected,
            items: viewModel.state.toList(),
            itemAsString: (i) => i.name.toString(),
            isSearch: true,
            onChanged: onChanged),);

Future<void> showQRCode(
        BuildContext context, int id, String name, String kmEndStore) =>
    showDialog<void>(
        context: context,
        builder: (BuildContext contextDialog) => AlertDialog(
                actionsPadding: EdgeInsets.zero,
                title: Padding(
                    padding: EdgeInsets.only(left: mainPadding / 2),
                    child: Text("QR Vehicle Check", style: primary15Bold),),
                content: SizedBox(
                    width: 200,
                    height: 200,
                    child: Center(
                        child: QrImageView(
                            data: '{"data": ${jsonEncode({
                                  "id": id,
                                  "kmEndStore": kmEndStore,
                                  "type": "vehicle_check"
                                })}, "hash": "${sha256.convert(utf8.encode(jsonEncode({
                                      "id": id,
                                      "kmEndStore": kmEndStore,
                                      "type": "vehicle_check",
                                      "lockkey": "umgkhmererp"
                                    }),),).toString()}"}',
                            embeddedImage: const AssetImage('assets/images/logo.png'),
                            embeddedImageStyle: const QrEmbeddedImageStyle(
                              size: Size(35, 35),
                            ),
                            version: QrVersions.auto,
                            dataModuleStyle: const QrDataModuleStyle(
                              color: Colors.black87,
                            ),
                            backgroundColor: transparent,
                            errorCorrectionLevel: QrErrorCorrectLevel.H),),),
                actions: [
                  Center(
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: mainPadding),
                          child: Text(name,
                              textAlign: TextAlign.center,
                              style: titleStyle15),),),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                          padding: EdgeInsets.only(right: mainPadding / 2),
                          child: TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text('Close',
                                  style: primary12Bold.copyWith(
                                      color: redColor),),),))
                ]),);
