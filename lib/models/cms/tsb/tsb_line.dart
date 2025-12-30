import 'package:umgkh_mobile/models/cms/a4/selection/selection.dart';

class TsbLine {
  final int? id;
  final String? typePart;
  final Selection? product;
  final String? description;
  final int? qtyLine;

  TsbLine(
      {this.id, this.typePart, this.product, this.description, this.qtyLine});

  factory TsbLine.fromJson(Map<String, dynamic> json) {
    return TsbLine(
        id: json['id'] as int? ?? 0,
        typePart: json['type_part'] as String? ?? "",
        product: json['product'] != null
            ? Selection.fromJson(json['product'])
            : null,
        description: json['description'] as String? ?? "",
        qtyLine: json['qty_line'] as int? ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type_part': typePart,
      'product': product,
      'description': description,
      'qty_line': qtyLine
    };
  }
}
