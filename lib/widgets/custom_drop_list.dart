import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

// ================================================== OLD CODE
// class CustomDropList<T> extends StatefulWidget {
//   final List<T> items;
//   final String Function(T) itemAsString;
//   final void Function(T) onChanged;
//   final T selected;
//   final bool isValidate, isRemove, isSearch;
//   final String? titleHead;
//   final Function()? onRemove;
//   final bool enabled, readOnlyAndFilled;

//   const CustomDropList({
//     super.key,
//     required this.items,
//     required this.itemAsString,
//     required this.onChanged,
//     required this.selected,
//     this.isValidate = false,
//     this.isRemove = false,
//     this.isSearch = false,
//     this.titleHead,
//     this.onRemove,
//     this.enabled = true,
//     this.readOnlyAndFilled = false,
//   });

//   @override
//   State<CustomDropList<T>> createState() => _CustomDropListState<T>();
// }

// class _CustomDropListState<T> extends State<CustomDropList<T>> {
//   @override
//   Widget build(BuildContext context) =>
//       Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//         widget.titleHead != null
//             ? Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
//                 child: Text(widget.titleHead!, style: titleStyle13),
//               )
//             : sizedBoxShrink,
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//                 width: 1, color: widget.isValidate ? redColor : primaryColor),
//           ),
//           child: DropdownSearch<T>(
//             items: widget.items,
//             enabled: widget.enabled,
//             itemAsString: widget.itemAsString,
//             onChanged: (v) => v != null ? widget.onChanged(v) : null,
//             selectedItem: widget.selected,
//             clearButtonProps: ClearButtonProps(
//                 isVisible: widget.isRemove,
//                 padding: EdgeInsets.only(left: mainPadding * 4),
//                 splashRadius: 10,
//                 alignment: Alignment.center,
//                 highlightColor: transparent,
//                 splashColor: transparent,
//                 icon: const Icon(Icons.delete_forever_rounded),
//                 iconSize: 18,
//                 onPressed: widget.onRemove,
//                 color: Colors.red),
//             popupProps: PopupProps.menu(
//               fit: FlexFit.loose,
//               showSearchBox: widget.isSearch,
//               searchFieldProps: TextFieldProps(
//                   decoration: InputDecoration(
//                     hintText: 'Search...',
//                     hintStyle: hintStyle,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(mainRadius),
//                     ),
//                     suffixIcon: Icon(Icons.search_rounded,
//                         size: 20, color: primaryColor),
//                     contentPadding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   ),
//                   style: titleStyle15),
//               itemBuilder: (ctx, item, _) => Padding(
//                 padding: EdgeInsets.fromLTRB(mainPadding, mainPadding / 1.8,
//                     mainPadding, mainPadding / 1.8),
//                 child: Text(widget.itemAsString(item), style: primary13Bold),
//               ),
//               menuProps: MenuProps(
//                 backgroundColor: Colors.white,
//                 elevation: 8.0,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//               ),
//             ),
//             dropdownButtonProps: DropdownButtonProps(
//               icon: Icon(Icons.arrow_drop_down_rounded,
//                   size: 20,
//                   color: widget.readOnlyAndFilled
//                       ? Colors.grey.shade400
//                       : primaryColor),
//             ),
//             dropdownDecoratorProps: DropDownDecoratorProps(
//               baseStyle: widget.readOnlyAndFilled
//                   ? primary13Bold.copyWith(color: Colors.grey.shade400)
//                   : primary13Bold,
//               textAlign: TextAlign.start,
//               textAlignVertical: TextAlignVertical.center,
//               dropdownSearchDecoration: InputDecoration(
//                   contentPadding: EdgeInsets.only(left: mainPadding),
//                   border: InputBorder.none,
//                   disabledBorder: InputBorder.none,
//                   hintText: "Select ${widget.titleHead?.toLowerCase()}",
//                   hintStyle: hintStyle,
//                   errorBorder: InputBorder.none,
//                   enabledBorder: InputBorder.none,
//                   focusedBorder: InputBorder.none,
//                   focusedErrorBorder: InputBorder.none),
//             ),
//           ),
//         ),
//         widget.isValidate
//             ? Padding(
//                 padding: EdgeInsets.symmetric(horizontal: mainPadding),
//                 child: Text(
//                   'Please make your selection to continue!',
//                   style: hintStyle.copyWith(color: redColor, fontSize: 10),
//                 ),
//               )
//             : sizedBoxShrink
//       ]);
// }

// ================================================== SINGLE - SELECTION

class CustomDropList<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemAsString;
  final void Function(T) onChanged;
  final T selected;
  final bool isValidate, isRemove, isSearch;
  final String? titleHead, validateText;
  final Function()? onRemove;
  final bool enabled, readOnlyAndFilled;
  final void Function(String)? onCreate;
  final bool isSearchCreate, hasDropIcon;

  const CustomDropList({
    super.key,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    required this.selected,
    this.isValidate = false,
    this.isRemove = false,
    this.isSearch = false,
    this.titleHead,
    this.validateText,
    this.onRemove,
    this.enabled = true,
    this.readOnlyAndFilled = false,
    this.onCreate,
    this.isSearchCreate = false,
    this.hasDropIcon = true,
  });

  @override
  State<CustomDropList<T>> createState() => _CustomDropListState<T>();
}

class _CustomDropListState<T> extends State<CustomDropList<T>> {
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        widget.titleHead != null
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text(widget.titleHead!, style: titleStyle13))
            : sizedBoxShrink,
        Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    width: 1,
                    color: widget.isValidate
                        ? redColor
                        : widget.readOnlyAndFilled
                            ? Colors.grey.shade400
                            : primaryColor)),
            child: DropdownSearch<T>(
                items: widget.items,
                enabled: widget.enabled,
                itemAsString: widget.itemAsString,
                onChanged: (v) => v != null ? widget.onChanged(v) : null,
                selectedItem: widget.selected,
                clearButtonProps: buildClearButtonProps(
                    isRemove: widget.isRemove, onRemove: widget.onRemove),
                popupProps: !widget.isSearchCreate
                    ? buildPopupProps(
                        isSearch: widget.isSearch,
                        itemAsString: widget.itemAsString)
                    : buildPopupPropsWithCreate(
                        isSearch: widget.isSearch,
                        itemAsString: widget.itemAsString,
                        onCreate: widget.onCreate ?? (v) {}),
                // popupProps: buildPopupProps(
                //     isSearch: widget.isSearch,
                //     itemAsString: widget.itemAsString),
                dropdownButtonProps: buildDropdownButtonProps(
                    readOnlyAndFilled: widget.readOnlyAndFilled,
                    hasDropIcon: widget.hasDropIcon),
                dropdownDecoratorProps: buildDropDownDecoratorProps(
                    readOnlyAndFilled: widget.readOnlyAndFilled,
                    titleHead: widget.titleHead))),
        widget.isValidate
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: Text(
                    widget.validateText ??
                        'Please make your selection to continue!',
                    style: hintStyle.copyWith(color: redColor, fontSize: 10)))
            : sizedBoxShrink
      ]);
}

// =================================================================== MULTI - SELECTION
class CustomMultiDropList<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T) itemAsString;
  final void Function(List<T>) onChanged;
  final List<T> selected;
  final bool isValidate, enabled, readOnlyAndFilled;
  final String? titleHead, hint;
  final Function(T) onRemove;

  const CustomMultiDropList({
    super.key,
    required this.items,
    required this.itemAsString,
    required this.onChanged,
    required this.selected,
    this.isValidate = false,
    this.titleHead,
    required this.onRemove,
    this.enabled = true,
    this.readOnlyAndFilled = false,
    this.hint,
  });

  @override
  State<CustomMultiDropList<T>> createState() => _CustomMultiDropListState<T>();
}

class _CustomMultiDropListState<T> extends State<CustomMultiDropList<T>> {
  @override
  Widget
      build(BuildContext context) =>
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            widget.titleHead != null
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                    child: Text(widget.titleHead!, style: titleStyle13))
                : sizedBoxShrink,
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        width: 1,
                        color: widget.isValidate ? redColor : primaryColor)),
                child: DropdownSearch<T>.multiSelection(
                    enabled: widget.enabled,
                    items: widget.items,
                    selectedItems: widget.selected,
                    itemAsString: widget.itemAsString,
                    dropdownBuilder: (context, selectedItems) {
                      if (selectedItems.isEmpty) {
                        return Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                                widget.hint ??
                                    "Select ${widget.titleHead?.toLowerCase()}",
                                style: hintStyle));
                      }
                      return Wrap(
                          spacing: 5,
                          runSpacing: -8,
                          children: selectedItems
                              .map((item) => Chip(
                                  label: Text(widget.itemAsString(item),
                                      style: titleStyle11.copyWith(
                                          color: widget.readOnlyAndFilled
                                              ? Colors.black45
                                              : null)),
                                  backgroundColor: widget.readOnlyAndFilled
                                      ? Colors.grey.withOpacity(0.2)
                                      : primaryColor.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(mainRadius)),
                                  padding:
                                      EdgeInsets.only(left: mainPadding / 3),
                                  deleteIcon: IconButton(
                                      icon: Icon(Icons.close_rounded,
                                          color: widget.readOnlyAndFilled
                                              ? Colors.grey.shade400
                                              : redColor,
                                          size: 15),
                                      constraints: const BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      style:
                                          ButtonStyle(overlayColor: WidgetStateProperty.all(Colors.red.withOpacity(0.2)), shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(mainRadius)))),
                                      onPressed: () => widget.onRemove(item)),
                                  onDeleted: () {} // leave it blank: to enable remove func
                                  ))
                              .toList());
                    },
                    onChanged: (v) => v.isNotEmpty ? widget.onChanged(v) : [],
                    popupProps: buildPopupPropMulti(
                        isSearch: false, itemAsString: widget.itemAsString),
                    dropdownButtonProps: buildDropdownButtonProps(
                        readOnlyAndFilled: widget.readOnlyAndFilled),
                    dropdownDecoratorProps: buildDropDownDecoratorProps(
                        readOnlyAndFilled: widget.readOnlyAndFilled,
                        titleHead: widget.titleHead,
                        padding: EdgeInsets.only(left: mainPadding / 2)))),
            widget.isValidate
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: mainPadding),
                    child: Text('Please make your selection to continue!',
                        style:
                            hintStyle.copyWith(color: redColor, fontSize: 10)))
                : sizedBoxShrink
          ]);
}

// =================================================================== widget build multi

PopupPropsMultiSelection<T> buildPopupPropMulti<T>(
        {required bool isSearch,
        required final String Function(T) itemAsString}) =>
    PopupPropsMultiSelection.menu(
        fit: FlexFit.loose,
        showSearchBox: isSearch,
        searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: hintStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainRadius)),
                suffixIcon:
                    Icon(Icons.search_rounded, size: 20, color: primaryColor),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            style: titleStyle15),
        itemBuilder: (ctx, item, _) => Padding(
            padding: EdgeInsets.fromLTRB(
                mainPadding, mainPadding / 1.8, mainPadding, mainPadding / 1.8),
            child: Text(itemAsString(item), style: primary13Bold)),
        menuProps: MenuProps(
            backgroundColor: Colors.white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))));

// =================================================================== widget build single
ClearButtonProps buildClearButtonProps<T>(
        {required bool isRemove, required Function()? onRemove}) =>
    ClearButtonProps(
        isVisible: isRemove,
        padding: EdgeInsets.only(left: mainPadding * 4),
        splashRadius: 10,
        alignment: Alignment.center,
        highlightColor: transparent,
        splashColor: transparent,
        icon: const Icon(Icons.delete_forever_rounded),
        iconSize: 18,
        onPressed: onRemove,
        color: Colors.red);

PopupProps<T> buildPopupProps<T>(
        {required bool isSearch,
        required final String Function(T) itemAsString}) =>
    PopupProps.menu(
        fit: FlexFit.loose,
        showSearchBox: isSearch,
        searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: hintStyle,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainRadius)),
                suffixIcon:
                    Icon(Icons.search_rounded, size: 20, color: primaryColor),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            style: titleStyle15),
        itemBuilder: (ctx, item, _) => Padding(
              padding: EdgeInsets.fromLTRB(mainPadding, mainPadding / 1.8,
                  mainPadding, mainPadding / 1.8),
              child: Text(itemAsString(item), style: primary13Bold),
            ),
        menuProps: MenuProps(
            backgroundColor: Colors.white,
            elevation: 8.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0))));

DropdownButtonProps buildDropdownButtonProps(
        {required bool readOnlyAndFilled, bool hasDropIcon = true}) =>
    DropdownButtonProps(
        icon: hasDropIcon
            ? Icon(Icons.arrow_drop_down_rounded,
                size: 20,
                color: readOnlyAndFilled ? Colors.grey.shade400 : primaryColor)
            : sizedBoxShrink);

DropDownDecoratorProps buildDropDownDecoratorProps(
        {required bool readOnlyAndFilled,
        required String? titleHead,
        EdgeInsetsGeometry? padding}) =>
    DropDownDecoratorProps(
        baseStyle: readOnlyAndFilled
            ? primary13Bold.copyWith(color: Colors.grey.shade400)
            : primary13Bold,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        dropdownSearchDecoration: InputDecoration(
            contentPadding: padding ?? EdgeInsets.only(left: mainPadding),
            border: InputBorder.none,
            disabledBorder: InputBorder.none,
            hintText: "Select ${titleHead?.toLowerCase()}",
            hintStyle: hintStyle,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none));

//===================================> On search when no data match have button create <====================================
PopupProps<T> buildPopupPropsWithCreate<T>({
  required bool isSearch,
  required String Function(T) itemAsString,
  required void Function(String) onCreate,
}) {
  return PopupProps.menu(
    fit: FlexFit.loose,
    showSearchBox: isSearch,
    searchFieldProps: TextFieldProps(
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: hintStyle,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(mainRadius),
        ),
        suffixIcon: Icon(Icons.search_rounded, size: 20, color: primaryColor),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      style: titleStyle15,
    ),
    emptyBuilder: (context, searchEntry) {
      if (searchEntry.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton.icon(
          // onPressed: () => onCreate(searchEntry),
          onPressed: () {
            onCreate(searchEntry);
            // CLOSE POPUP
            Navigator.of(context, rootNavigator: true).pop();
          },
          icon: const Icon(Icons.add, size: 16),
          label: Text('Create "$searchEntry"'),
        ),
      );
    },
    itemBuilder: (context, item, isSelected) => Padding(
      padding: EdgeInsets.fromLTRB(
          mainPadding, mainPadding / 1.8, mainPadding, mainPadding / 1.8),
      child: Text(itemAsString(item), style: primary13Bold),
    ),
    menuProps: MenuProps(
      backgroundColor: Colors.white,
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );
}
