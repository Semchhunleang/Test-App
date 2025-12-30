import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umgkh_mobile/utils/constants.dart';
import 'package:umgkh_mobile/utils/theme.dart';
import 'package:umgkh_mobile/view_models/selections_view_model.dart';
import 'package:umgkh_mobile/widgets/custom_drop_list.dart';
import 'package:umgkh_mobile/widgets/widget_image.dart';

// =============================== STAGE FOR SERVICES
Widget filterFieldServiceStage(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: selected,
            items: viewModel.fieldServiceStage.toList(),
            itemAsString: (i) => i.name.toString(),
            onChanged: onChanged),
      ),
    );

// =============================== STATUS JOB ASSIGN LINE
Widget filterJobAssignLineStatus(
        {required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => Expanded(
        child: CustomDropList(
            selected: selected,
            items: viewModel.jalStatus.toList(),
            itemAsString: (i) => i.name.toString(),
            onChanged: onChanged),
      ),
    );

// =============================== CUSTOMER SATISFIED - FORM - JOB FINISH
Widget selectCustomerSatisfied(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Customer Satisfied',
          isValidate: validate,
          selected: selected,
          items: viewModel.customerSatisfied.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== SYSTEM COMPONENT - FORM - JOB ANALYTIC
Widget selectSystemComponent(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'System Component',
          isValidate: validate,
          selected: selected,
          items: viewModel.systemComponent.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== PHENOMENON - FORM - JOB ANALYTIC
Widget selectPhenomenon(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Phenomenon',
          isValidate: validate,
          selected: selected,
          items: viewModel.fsPhenomenon.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== ACTION - FORM - JOB ANALYTIC
Widget selectAction(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Action',
          isValidate: validate,
          selected: selected,
          items: viewModel.fsAction.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== ACTION BY - FORM - JOB ANALYTIC
Widget selectActionBy(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Action By',
          isValidate: validate,
          selected: selected,
          isSearch: true,
          items: viewModel.employees.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== SERVICE JOB POINT - FORM - JOB ANALYTIC
Widget selectServiceJobPoint(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
          titleHead: 'Service Job Point',
          isValidate: validate,
          selected: selected,
          items: viewModel.serviceJobPoint.toList(),
          itemAsString: (i) => i.name.toString(),
          onChanged: onChanged),
    );

// =============================== FLEET VEHICLE - FORM - Timesheet
Widget selectFleetVehicle(
        {required bool validate,
        required dynamic selected,
        required dynamic Function(dynamic) onChanged}) =>
    Consumer<SelectionsViewModel>(
      builder: (context, viewModel, _) => CustomDropList(
        titleHead: 'Vehicle',
        isValidate: validate,
        selected: selected,
        items: viewModel.fleetVehicle.toList(),
        itemAsString: (i) => i.name.toString(),
        onChanged: onChanged,
        isSearch: true,
      ),
    );

// =============================== IMAGES FOR FS - ALL

imageFieldServies(BuildContext context, List<int> data) => Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: data.asMap().entries.map((entry) {
        return widgetImg(entry.value, onTap: () {
          // navPush(
          //     context,
          //     ViewFullImagePage(
          //       index: entry.key,
          //     ),);
        });
      }).toList(),
    );

double imgSize = 35.5;
Widget widgetImg(int id, {Function()? onTap}) => Padding(
    padding: const EdgeInsets.only(right: 5),
    child: GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(mainRadius / 2),
        child: Image(
          height: imgSize,
          width: imgSize,
          image: NetworkImage(
            Constants.fsPicture(id),
          ),
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return SizedBox(
              height: imgSize,
              width: imgSize,
              child: const Center(
                child: WidgetLoadImage(),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              Container(height: imgSize, width: imgSize, color: Colors.white),
        ),
      ),
    ));
