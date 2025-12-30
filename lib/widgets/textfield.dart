import 'package:flutter/material.dart';
import 'package:umgkh_mobile/utils/theme.dart';

class InputTextField extends StatelessWidget {
  final TextEditingController ctrl;
  final String title, hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? suffixText;
  final String validatedText;
  final bool isValidate;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final int? maxLength;
  final bool readOnly, enableSelectText, readOnlyAndFilled, obscureText;
  final bool isNoTitle;
  final Widget? suffixIcon;

  const InputTextField({
    super.key,
    required this.ctrl,
    this.title = 'Title',
    this.hint = 'Enter data',
    this.keyboardType,
    this.textInputAction,
    this.suffixText,
    this.validatedText = "",
    this.isValidate = false,
    this.focusNode,
    this.onChanged,
    this.maxLength,
    this.readOnly = false,
    this.enableSelectText = true,
    this.readOnlyAndFilled = false,
    this.obscureText = false,
    this.isNoTitle = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        isNoTitle
            ? sizedBoxShrink
            : Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
                child: Text(title, style: titleStyle13)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1,
                  color: validatedText == ""
                      ? readOnlyAndFilled
                          ? Colors.grey.shade400
                          : primaryColor
                      : redColor)),
          child: TextField(
            controller: ctrl,
            style: readOnlyAndFilled
                ? primary13Bold.copyWith(color: Colors.grey.shade400)
                : primary13Bold,
            keyboardType: keyboardType ?? TextInputType.text,
            textInputAction: textInputAction ?? TextInputAction.done,
            focusNode: focusNode,
            onChanged: onChanged,
            maxLength: maxLength,
            readOnly: readOnly,
            obscureText: obscureText,
            enableInteractiveSelection: enableSelectText,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: hint,
                hintStyle: hintStyle,
                suffixText: suffixText,
                suffixStyle: readOnlyAndFilled
                    ? primary13Bold.copyWith(color: Colors.grey.shade400)
                    : primary13Bold,
                counterText: "",
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: suffixIcon),
          ),
        ),
        isValidate
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: Text(
                  validatedText,
                  style: hintStyle.copyWith(color: redColor, fontSize: 10),
                ),
              )
            : sizedBoxShrink
      ]);
}

class MutliLineTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final String title, hint;
  final String validatedText;
  final bool isValidate, readOnly, enableSelectText, readOnlyAndFilled;
  final Function(String)? onChanged;
  final int? minLine, maxLine;

  const MutliLineTextField({
    super.key,
    required this.ctrl,
    this.title = 'Title',
    this.hint = 'Enter your reason',
    this.validatedText = "Field required",
    this.isValidate = false,
    this.readOnly = false,
    this.enableSelectText = true,
    this.onChanged,
    this.minLine,
    this.maxLine = 4,
    this.readOnlyAndFilled = false,
  });

  @override
  State<MutliLineTextField> createState() => _MutliLineTextFieldState();
}

class _MutliLineTextFieldState extends State<MutliLineTextField> {
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
          child: Text(widget.title, style: titleStyle13),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1,
                  color: widget.isValidate
                      ? redColor
                      : widget.readOnlyAndFilled
                          ? Colors.grey.shade400
                          : primaryColor)),
          child: TextField(
            controller: widget.ctrl,
            maxLines: widget.maxLine,
            minLines: widget.minLine,
            style: widget.readOnlyAndFilled
                ? primary13Bold.copyWith(color: Colors.grey.shade400)
                : primary13Bold,
            readOnly: widget.readOnly,
            keyboardType: TextInputType.multiline,
            onChanged: widget.onChanged,
            enableInteractiveSelection: widget.enableSelectText,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: widget.hint,
                hintStyle: hintStyle,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none),
          ),
        ),
        widget.isValidate
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: mainPadding),
                child: Text(
                  widget.validatedText,
                  style: hintStyle.copyWith(color: redColor, fontSize: 10),
                ),
              )
            : sizedBoxShrink
      ]);
}

class SearchTextfield extends StatefulWidget {
  final TextEditingController? ctrl;
  final Function(String)? onChanged;
  final Function()? onEditing;
  final String? initialValue;

  const SearchTextfield({
    super.key,
    this.ctrl,
    this.onChanged,
    this.onEditing,
    this.initialValue,
  });

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl =
        widget.ctrl ?? TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    if (widget.ctrl == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: primaryColor)),
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: _ctrl,
          builder: (_, value, __) => TextFormField(
            controller: _ctrl,
            style: primary13Bold,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditing,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  vertical: mainPadding, horizontal: mainPadding / 2),
              hintText: 'What are you searching for ?',
              hintStyle: hintStyle,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: IconButton(
                icon: Icon(
                  value.text.isEmpty
                      ? Icons.search_rounded
                      : Icons.clear_rounded,
                  color: value.text.isEmpty ? primaryColor : redColor,
                ),
                onPressed: value.text.isEmpty
                    ? null
                    : () {
                        _ctrl.clear();
                        widget.onChanged?.call('');
                      },
              ),
            ),
          ),
        ),
      );
}

class SearchMenuTextField extends StatelessWidget {
  final TextEditingController? ctrl;
  final Function(String)? onChanged;
  final Function()? onRemoveText;

  const SearchMenuTextField(
      {super.key, this.ctrl, this.onChanged, this.onRemoveText});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: primaryColor),
          ),
          child: TextFormField(
            controller: ctrl,
            style: primary12Bold,
            keyboardType: TextInputType.text,
            cursorHeight: 10,
            onChanged: onChanged,
            onEditingComplete: () => FocusScope.of(context).requestFocus(
              FocusNode(),
            ),
            decoration: InputDecoration(
              hintText: 'Search menu',
              contentPadding: const EdgeInsets.all(10),
              hintStyle: hintStyle.copyWith(fontSize: 10),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIconConstraints: const BoxConstraints(),
              suffixIcon: ctrl != null && ctrl!.text.isEmpty
                  ? const Icon(Icons.search_rounded, size: 15)
                  : InkWell(
                      onTap: onRemoveText,
                      highlightColor: transparent,
                      splashColor: transparent,
                      borderRadius: BorderRadius.circular(mainRadius),
                      child:
                          Icon(Icons.close_rounded, size: 18, color: redColor),
                    ),
            ),
          ),
        ),
      );
}

class CommentTextField extends StatefulWidget {
  final TextEditingController ctrl;
  final Function(String)? onChanged;
  final void Function()? onFile;
  final int? minLine, maxLine;

  const CommentTextField({
    super.key,
    required this.ctrl,
    this.onChanged,
    this.minLine,
    this.maxLine = 4,
    this.onFile,
  });

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
                color: whiteColor.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
                border:
                    Border.all(width: 0.5, color: greyColor.withOpacity(0.4))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(
                  child: TextField(
                      controller: widget.ctrl,
                      maxLines: widget.maxLine,
                      minLines: widget.minLine,
                      style: primary12Bold.copyWith(
                          color: blackColor.withOpacity(0.6)),
                      keyboardType: TextInputType.multiline,
                      onChanged: widget.onChanged,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                          hintText: 'What is on your mind ?',
                          hintStyle: hintStyle.copyWith(fontSize: 10),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none))),
              widget.onFile != null
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 2.5),
                      child: icon(Icons.attach_file_rounded))
                  : sizedBoxShrink
            ]))
      ]);

  Widget icon(IconData icon) => Material(
      color: transparent,
      child: InkWell(
          onTap: widget.onFile,
          borderRadius: BorderRadius.circular(mainRadius * 2),
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.1),
          child: Padding(
              padding: EdgeInsets.all(mainPadding / 3),
              child: Icon(icon, size: 19, weight: 800, color: primaryColor))));
}
