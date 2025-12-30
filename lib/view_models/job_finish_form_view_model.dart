import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:umgkh_mobile/models/base/data/static_selection.dart';
import 'package:umgkh_mobile/services/api/field_service/fs_api_service.dart';
import 'package:umgkh_mobile/utils/show_dialog.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/utils/utlis.dart';
import 'package:umgkh_mobile/view_models/field_service_view_model.dart';

class JobFinishFormViewModel extends ChangeNotifier {
  bool isCusSatisfied = false, isCustomer = false, isPhone = false;
  bool isComment = false,
      isRecommend = false,
      isSign = false,
      isSignMechanic = false;
  TextEditingController customerCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController commentCtrl = TextEditingController();
  TextEditingController recommendCtrl = TextEditingController();
  StaticSelection customerSatisfied =
      StaticSelection(id: 0, name: 'Selection customer satisfied');
  late SignatureController controller;
  late SignatureController mechanicSignatureController;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  JobFinishFormViewModel() {
    controller = SignatureController(
        penStrokeWidth: 1,
        penColor: Colors.red,
        exportBackgroundColor: whiteColor,
        exportPenColor: Colors.black,
        onDrawStart: () {},
        onDrawEnd: onChangeDraw);
    mechanicSignatureController = SignatureController(
        penStrokeWidth: 1,
        penColor: Colors.red,
        exportBackgroundColor: whiteColor,
        exportPenColor: Colors.black,
        onDrawStart: () {},
        onDrawEnd: onChangeDrawSignMechanic);
  }

  void notify<T>(T v, void Function(T) setter) {
    setter(v);
    notifyListeners();
  }

  onChangeCustomerSatisfied(dynamic v) => notify(v, (val) {
        customerSatisfied = val;
        isCusSatisfied = customerSatisfied.id == 0;
      });

  onChangeCustomer(String v) =>
      notify(v, (v) => isCustomer = trimStr(v).isEmpty);

  onChangePhone(String v) => notify(v, (v) => isPhone = trimStr(v).isEmpty);

  onChangeComment(String v) => notify(v, (v) => isComment = trimStr(v).isEmpty);

  onChangeRecommend(String v) =>
      notify(v, (v) => isRecommend = trimStr(v).isEmpty);

  onChangeDraw() async {
    final image = await controller.toImage();
    final hasDrawn =
        image != null && (await image.toByteData())?.lengthInBytes != 0;
    notify(hasDrawn, (p) => isSign = !p);
  }

  onChangeDrawSignMechanic() async {
    final image = await mechanicSignatureController.toImage();
    final hasDrawn =
        image != null && (await image.toByteData())?.lengthInBytes != 0;
    notify(hasDrawn, (p) => isSignMechanic = !p);
  }

  Future<bool> isValidated() async {
    onChangeCustomerSatisfied(customerSatisfied);
    onChangeCustomer(customerCtrl.text);
    onChangePhone(phoneCtrl.text);
    onChangeComment(commentCtrl.text);
    onChangeRecommend(recommendCtrl.text);
    await onChangeDraw();
    await onChangeDrawSignMechanic();
    return isCusSatisfied ||
        isCustomer ||
        isPhone ||
        isComment ||
        isRecommend ||
        isSign ||
        isSignMechanic;
  }

  Future<void> insertData(BuildContext context, int id) async {
    _isLoading = true;
    try {
      // File imageFile = await signToPng();
      final customerSignatureFile = await signToPng(controller);
      final mechanicSignatureFile =
          await signToPng(mechanicSignatureController);

      if (!await customerSignatureFile.exists() ||
          !await mechanicSignatureFile.exists()) {
        throw Exception("Signature file(s) do not exist");
      }

      // // Check if the file exists
      // if (!await imageFile.exists()) {
      //   throw Exception("File does not exist at path: ${imageFile.path}");
      // }

      Map<String, dynamic> data = {
        "job_finish_project_id": id,
        'customer_satisfied': customerSatisfied.value,
        'customer_name': customerCtrl.text,
        'phone': phoneCtrl.text,
        'customer_comment': commentCtrl.text,
        'service_recommendation': recommendCtrl.text,
        'image_path': customerSignatureFile.path,
        'mechanic_signature_path': mechanicSignatureFile.path,
        "finish_datetime": rollbackParseDateTime(DateTime.now()),
      };

      await FieldServiceAPIService().insertJobFinish(
          [customerSignatureFile, mechanicSignatureFile], data).then((value) {
        if (context.mounted) {
          showResultDialog(context, '${value.message}',
              isBackToList: !value.message!.contains('error'));
          if (!value.message!.contains('error')) {
            final viewModelFS =
                Provider.of<FieldServiceViewModel>(context, listen: false);
            viewModelFS.updateStageFieldService(id, "Job Finish");
          }
        }
        _isLoading = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error in insertData: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<File> signToPng(SignatureController targetController) async {
    final tempDir = await getTemporaryDirectory();
    final Uint8List data = await targetController.toPngBytes() ?? Uint8List(0);

    final File fileToBeUploaded =
        await File('${tempDir.path}/${generateRandomString(10)}.png').create();

    await fileToBeUploaded.writeAsBytes(data);

    if (await fileToBeUploaded.exists()) {
      debugPrint('File created successfully at: ${fileToBeUploaded.path}');
    } else {
      throw Exception(
          "Failed to create file at path: ${fileToBeUploaded.path}");
    }

    return fileToBeUploaded;
  }

  // Future<File> signToPng() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final Uint8List data = await controller.toPngBytes() ?? Uint8List(0);

  //   // Generate a file path
  //   File fileToBeUploaded =
  //       File('${tempDir.path}/${generateRandomString(10)}.png');

  //   // Create the file and write data to it
  //   fileToBeUploaded = await fileToBeUploaded.create();
  //   await fileToBeUploaded.writeAsBytes(data);

  //   // Confirm file creation and log path
  //   if (await fileToBeUploaded.exists()) {
  //     debugPrint('File created successfully at: ${fileToBeUploaded.path}');
  //   } else {
  //     throw Exception(
  //         "Failed to create file at path: ${fileToBeUploaded.path}");
  //   }

  //   return fileToBeUploaded;
  // }

  String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = math.Random.secure();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => chars.codeUnitAt(
        random.nextInt(chars.length),
      ),
    ));
  }

  undo() => notify(null, (v) => controller.undo());
  redo() => notify(null, (v) => controller.redo());
  clear() => notify(null, (v) => controller.clear());

  undoMechanicSign() => notify(null, (v) => mechanicSignatureController.undo());
  redoMechanicSign() => notify(null, (v) => mechanicSignatureController.redo());
  clearMechanicSign() =>
      notify(null, (v) => mechanicSignatureController.clear());

  // Future<File> signToPng() async {
  //   final tempDir = await getTemporaryDirectory();
  //   final Uint8List data = await controller.toPngBytes() ?? Uint8List(0);
  //   File fileToBeUploaded =
  //       await File('${tempDir.path}/${generateRandomString(10)}.png').create();
  //   return await fileToBeUploaded.writeAsBytes(data);
  // }

  resetValidate() => isCusSatisfied = isCustomer =
      isPhone = isComment = isRecommend = isSign = isSignMechanic = false;

  resetForm() {
    _isLoading = false;
    customerSatisfied =
        StaticSelection(id: 0, name: 'Selection customer satisfied');
    customerCtrl.clear();
    phoneCtrl.clear();
    commentCtrl.clear();
    recommendCtrl.clear();
    controller.clear();
    mechanicSignatureController.clear();
  }
}
