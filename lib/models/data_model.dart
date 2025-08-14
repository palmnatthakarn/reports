import 'package:json_annotation/json_annotation.dart';

part 'data_model.g.dart';

@JsonSerializable()
class ApiResponse {
  final String status;
  @JsonKey(name: 'data')
  final List<Data> data;
  final Meta meta;

  ApiResponse({
    required this.status,
    required this.data,
    required this.meta,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => _$ApiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

@JsonSerializable()
class Data {
  @JsonKey(name: 'doc_date', fromJson: _parseDateTimeNonNull)
  final DateTime docDate;
  @JsonKey(name: 'total_value', defaultValue: 0)
  final double totalValue;
  @JsonKey(name: 'detail_total_discount', defaultValue: 0)
  final double detailTotalDiscount;
  @JsonKey(name: 'total_except_vat', defaultValue: 0)
  final double totalExceptVat;
  @JsonKey(name: 'total_before_vat', defaultValue: 0)
  final double totalBeforeVat;
  @JsonKey(name: 'total_vat_value', defaultValue: 0)
  final double totalVatValue;
  @JsonKey(name: 'detail_total_amount', defaultValue: 0)
  final double detailTotalAmount;
  @JsonKey(name: 'total_discount', defaultValue: 0)
  final double totalDiscount;
  @JsonKey(name: 'total_amount', defaultValue: 0)
  final double totalAmount;

  Data({
    required this.docDate,
    required this.totalValue,
    required this.detailTotalDiscount,
    required this.totalExceptVat,
    required this.totalBeforeVat,
    required this.totalVatValue,
    required this.detailTotalAmount,
    required this.totalDiscount,
    required this.totalAmount,
  });
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

DateTime _parseDateTimeNonNull(dynamic value) {
  if (value == null) {
    throw FormatException("docDate is missing or null");
  }
  final parsed = DateTime.tryParse(value.toString());
  if (parsed == null) {
    throw FormatException("Invalid date format for docDate: $value");
  }
  return parsed;
}

@JsonSerializable()
class Meta {
  @JsonKey(name: 'page')
  final int page;
  @JsonKey(name: 'size')
  final int size;
  @JsonKey(name: 'total')
  final int total;
  @JsonKey(name: 'total_page')
  final int totalPage;

  Meta({
    required this.page,
    required this.size,
    required this.total,
    required this.totalPage,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Summary {
  final double totalValue;
  final double totalDiscount;
  final double totalExceptVat;
  final double totalBeforeVat;
  final double totalVatValue;
  final double totalAfterDiscount;
  final double totalFinalDiscount;
  final double totalAmount;

  Summary({
    required this.totalValue,
    required this.totalDiscount,
    required this.totalExceptVat,
    required this.totalBeforeVat,
    required this.totalVatValue,
    required this.totalAfterDiscount,
    required this.totalFinalDiscount,
    required this.totalAmount,
  });

  static Summary calculate(List<Data> reports) {
    double totalValue = 0;
    double totalDiscount = 0;
    double totalExceptVat = 0;
    double totalBeforeVat = 0;
    double totalVatValue = 0;
    double totalAfterDiscount = 0;
    double totalFinalDiscount = 0;
    double totalAmount = 0;

    for (var item in reports) {
      totalValue += item.totalValue;
      totalDiscount += item.detailTotalDiscount;
      totalExceptVat += item.totalExceptVat;
      totalBeforeVat += item.totalBeforeVat;
      totalVatValue += item.totalVatValue;
      totalAfterDiscount += item.detailTotalAmount;
      totalFinalDiscount += item.totalDiscount;
      totalAmount += item.totalAmount;
    }
    return Summary(
      totalValue: totalValue,
      totalDiscount: totalDiscount,
      totalExceptVat: totalExceptVat,
      totalBeforeVat: totalBeforeVat,
      totalVatValue: totalVatValue,
      totalAfterDiscount: totalAfterDiscount,
      totalFinalDiscount: totalFinalDiscount,
      totalAmount: totalAmount,
    );
  }
    factory Summary.fromJson(Map<String, dynamic> json) => _$SummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}
