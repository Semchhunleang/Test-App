import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';

// =============================== STATUS
Widget filterSelectStatus(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: viewModel.statusSmallPaper[selected],
            items: viewModel.statusSmallPaper.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.statusSmallPaper.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );

// =============================== PEOPLE
Widget filterSelectPeople(
        {required String selected, required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: viewModel.people[selected],
            items: viewModel.people.values.toList(),
            itemAsString: (i) => i.toString(),
            onChanged: (v) {
              final selectedKey = viewModel.people.entries
                  .firstWhere((entry) => entry.value == v)
                  .key;
              onValue(selectedKey);
            }),
      ),
    );

// =============================== TRANSPORTATION TYPE
Widget selectTransportation(
        {required bool isValidate,
        required bool enable,
        required String selected,
        required Function(String) onValue}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
        enabled: enable,
        titleHead: 'Transportation',
        isValidate: isValidate,
        selected: viewModel.transportationType[selected],
        items: viewModel.transportationType.values.toList(),
        itemAsString: (i) => i.toString(),
        onChanged: (v) {
          final selectedKey = viewModel.transportationType.entries
              .firstWhere((entry) => entry.value == v)
              .key;
          onValue(selectedKey);
        },
      ),
    );

// =============================== SHOW QR
Future<void> showQRCode(
        BuildContext context, int id, String name, String type) =>
    showDialog<void>(
      context: context,
      builder: (BuildContext contextDialog) => AlertDialog(
        actionsPadding: EdgeInsets.zero,
        title: Padding(
          padding: EdgeInsets.only(left: mainPadding / 2),
          child: Text("QR Small Paper", style: primary15Bold),
        ),
        content: SizedBox(
          width: 200,
          height: 200,
          child: Center(
            child: QrImageView(
                data: '{"data": ${jsonEncode({
                      "id": id,
                      "type": "small_paper"
                    })}, "hash": "${sha256.convert(
                      utf8.encode(
                        jsonEncode({
                          "id": id,
                          "type": "small_paper",
                          "lockkey": "umgkhmererp"
                        }),
                      ),
                    ).toString()}"}',
                version: QrVersions.auto,
                embeddedImage: const AssetImage('assets/images/logo.png'),
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(35, 35),
                ),
                // foregroundColor: Colors.black87,
                eyeStyle: const QrEyeStyle(color: Colors.black),
                dataModuleStyle: const QrDataModuleStyle(color: Colors.black),
                backgroundColor: transparent,
                errorCorrectionLevel: QrErrorCorrectLevel.H),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mainPadding),
              child:
                  Text(name, textAlign: TextAlign.center, style: titleStyle15),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.only(right: mainPadding / 2),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Close',
                    style: primary12Bold.copyWith(color: redColor),
                  ),
                ),
              ))
        ],
      ),
    );
