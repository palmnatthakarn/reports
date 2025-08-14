// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
      'meta': instance.meta,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      docDate: _parseDateTimeNonNull(json['doc_date']),
      totalValue: (json['total_value'] as num?)?.toDouble() ?? 0,
      detailTotalDiscount:
          (json['detail_total_discount'] as num?)?.toDouble() ?? 0,
      totalExceptVat: (json['total_except_vat'] as num?)?.toDouble() ?? 0,
      totalBeforeVat: (json['total_before_vat'] as num?)?.toDouble() ?? 0,
      totalVatValue: (json['total_vat_value'] as num?)?.toDouble() ?? 0,
      detailTotalAmount: (json['detail_total_amount'] as num?)?.toDouble() ?? 0,
      totalDiscount: (json['total_discount'] as num?)?.toDouble() ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'doc_date': instance.docDate.toIso8601String(),
      'total_value': instance.totalValue,
      'detail_total_discount': instance.detailTotalDiscount,
      'total_except_vat': instance.totalExceptVat,
      'total_before_vat': instance.totalBeforeVat,
      'total_vat_value': instance.totalVatValue,
      'detail_total_amount': instance.detailTotalAmount,
      'total_discount': instance.totalDiscount,
      'total_amount': instance.totalAmount,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      page: (json['page'] as num?)?.toInt() ?? 1,
      size: (json['size'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPage: (json['total_page'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'total': instance.total,
      'total_page': instance.totalPage,
    };

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
      totalValue: (json['totalValue'] as num).toDouble(),
      totalDiscount: (json['totalDiscount'] as num).toDouble(),
      totalExceptVat: (json['totalExceptVat'] as num).toDouble(),
      totalBeforeVat: (json['totalBeforeVat'] as num).toDouble(),
      totalVatValue: (json['totalVatValue'] as num).toDouble(),
      totalAfterDiscount: (json['totalAfterDiscount'] as num).toDouble(),
      totalFinalDiscount: (json['totalFinalDiscount'] as num).toDouble(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
      'totalValue': instance.totalValue,
      'totalDiscount': instance.totalDiscount,
      'totalExceptVat': instance.totalExceptVat,
      'totalBeforeVat': instance.totalBeforeVat,
      'totalVatValue': instance.totalVatValue,
      'totalAfterDiscount': instance.totalAfterDiscount,
      'totalFinalDiscount': instance.totalFinalDiscount,
      'totalAmount': instance.totalAmount,
    };
