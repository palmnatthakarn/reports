import 'package:equatable/equatable.dart';
import '../models/data_model.dart';

abstract class ReportState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final List<Data> reports;
  final List<Data> filteredReports;
  final List<Data> allReports;
  final int currentStep;

  final DateTime? startDate;
  final DateTime? endDate;
  final String? selectedReportType;
  final Map<int, dynamic> cardData;
  final bool showOnlyInStock;
  final List<Data> productSelected;
  final Set<int> selectedIndexes;
  final int currentPage;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;

  ReportLoaded(
    this.reports, {
    List<Data>? filtered,
    List<Data>? allReports,
    this.currentStep = 0,

    this.startDate,
    this.endDate,
    this.selectedReportType,
    Map<int, dynamic>? cardData,
    this.showOnlyInStock = false,
    this.productSelected = const [],
    Set<int>? selectedIndexes,
    this.currentPage = 1,
    this.itemsPerPage = 5,
    this.itemsPerPageOptions = const [10, 20, 30, 40],
    
  })  : filteredReports = filtered ?? reports,
        allReports = allReports ?? reports,
        cardData = cardData ?? {},
        selectedIndexes = selectedIndexes ?? <int>{};

  List<Data> get paginatedReports {
    final start = (currentPage - 1) * itemsPerPage;
    final end = (start + itemsPerPage).clamp(0, allReports.length);
    return allReports.sublist(start, end);
  }

  ReportLoaded copyWith({
    List<Data>? reports,
    List<Data>? filteredReports,
    List<Data>? allReports,
    int? currentStep,

    DateTime? startDate,
    DateTime? endDate,
    String? selectedReportType,
    Map<int, dynamic>? cardData,
    bool? showOnlyInStock,
    List<Data>? productSelected,
    Set<int>? selectedIndexes,
    int? currentPage,
    int? itemsPerPage,
    List<int>? itemsPerPageOptions,
  }) {
    return ReportLoaded(
      reports ?? this.reports,
      filtered: filteredReports ?? this.filteredReports,
      allReports: allReports ?? this.allReports,
      currentStep: currentStep ?? this.currentStep,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedReportType: selectedReportType ?? this.selectedReportType,
      cardData: cardData ?? this.cardData,
      showOnlyInStock: showOnlyInStock ?? this.showOnlyInStock,
      productSelected: productSelected ?? this.productSelected,
      selectedIndexes: selectedIndexes ?? this.selectedIndexes,
      currentPage: currentPage ?? this.currentPage,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      itemsPerPageOptions: itemsPerPageOptions ?? this.itemsPerPageOptions,
    );
  }

  int get totalPages => (filteredReports.length / itemsPerPage).ceil();

  List<Data> get pagedReports {
    final start = (currentPage - 1) * itemsPerPage;
    final end = start + itemsPerPage;
    return filteredReports.sublist(
      start.clamp(0, filteredReports.length),
      end.clamp(0, filteredReports.length),
    );
  }

  bool hasDataForStep(int index) {
    final data = cardData[index];
    if (data == null) return false;
    if (data is String) return data.trim().isNotEmpty;
    if (data is List || data is Map) return data.isNotEmpty;
    return true;
  }

  @override
  List<Object> get props => [
        reports,
        filteredReports,
        allReports,
        currentStep,

        cardData,
        showOnlyInStock,
        productSelected,
        startDate ?? DateTime.now(),
        endDate ?? DateTime.now(),
        selectedReportType ?? '',
        selectedIndexes,
        currentPage,
        itemsPerPage,
        itemsPerPageOptions,
      ];
}

class ReportError extends ReportState {
  final String message;
  ReportError(this.message);

  @override
  List<Object> get props => [message];
}
