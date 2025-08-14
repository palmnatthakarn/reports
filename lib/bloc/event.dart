import 'package:equatable/equatable.dart';

import '../models/data_model.dart';

abstract class ReportEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event สำหรับอัปเดต filteredReports โดยตรง
class UpdateFilteredReportsEvent extends ReportEvent {
  final List<Data> filteredReports;
  UpdateFilteredReportsEvent(this.filteredReports);

  @override
  List<Object?> get props => [filteredReports];
  @override
  String toString() => 'UpdateFilteredReportsEvent(count: ${filteredReports.length})';
}

class LoadReportsEvent extends ReportEvent {
}

class SearchReportsEvent extends ReportEvent {
  final String keyword;
  SearchReportsEvent(this.keyword);

  @override
  List<Object> get props => [keyword];
}

class FilterReportsEvent extends ReportEvent {
  final int? month;
  final int? year;

  FilterReportsEvent({this.month, this.year});

  @override
  List<Object?> get props => [month, year];
}

class ApplyFilterEvent extends ReportEvent {
  final Set<int> selectedIndexes;

  ApplyFilterEvent(this.selectedIndexes);

  @override
  List<Object?> get props => [selectedIndexes];
}

class ClearFilterEvent extends ReportEvent {}

class ResetFilterToDefaultEvent extends ReportEvent {}


class SetDateRangeEvent extends ReportEvent {
  final DateTime? startDate;
  final DateTime? endDate;
 

  SetDateRangeEvent({required this.startDate, required this.endDate});

  @override
  List<Object?> get props => [startDate, endDate];
}

class SetStepEvent extends ReportEvent {
  final int currentStep;
  SetStepEvent(this.currentStep);

  @override
  List<Object?> get props => [currentStep];
}


class SelectReportType extends ReportEvent {
  final String reportType;
  SelectReportType(this.reportType);

  @override
  List<Object?> get props => [reportType];
}

class UpdateCardDataEvent extends ReportEvent {
  final int stepIndex;
  final dynamic data;

  UpdateCardDataEvent(this.stepIndex, this.data);

  @override
  List<Object?> get props => [stepIndex, data];
}

class ToggleInStockFilterEvent extends ReportEvent {
  final bool showOnlyInStock;

  ToggleInStockFilterEvent(this.showOnlyInStock);

  @override
  List<Object?> get props => [showOnlyInStock];
}

class ProductSelectedEvent extends ReportEvent {
  final List<Data> productSelected;

  ProductSelectedEvent(this.productSelected);

  @override
  List<Object?> get props => [productSelected];
}



class SelectProductEvent extends ReportEvent {}

class ResetSelectionEvent extends ReportEvent {}

class ChangePageEvent extends ReportEvent {
  final int page;
  ChangePageEvent(this.page);

  @override
  List<Object?> get props => [page];
}

class ChangeItemsPerPageEvent extends ReportEvent {
  final int itemsPerPage;
  ChangeItemsPerPageEvent(this.itemsPerPage);

  @override
  List<Object?> get props => [itemsPerPage];
}

class ProcessingEvent extends ReportEvent {
  final bool isProcessing;
  ProcessingEvent(this.isProcessing);

  @override
  List<Object?> get props => [isProcessing];
}