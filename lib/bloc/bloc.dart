import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:report/models/data_model.dart';
import 'event.dart';
import 'state.dart';
import '../repository/repository.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository repository;

  ReportBloc(this.repository) : super(ReportInitial()) {
    print('🧠 ReportBloc created');
    on<SearchReportsEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        final filtered = current.reports.where((item) {
          final dateStr = DateFormat('yyyy-MM-dd').format(item.docDate);
          return dateStr.contains(event.keyword) ||
              item.totalAmount.toString().contains(event.keyword);
        }).toList();

        emit(ReportLoaded(current.reports,
            filtered: filtered, allReports: current.allReports));
      }
    });
    // เพิ่มใน constructor ของ ReportBloc
    on<UpdateFilteredReportsEvent>((event, emit) {
      print(
          '🔄 UpdateFilteredReportsEvent received: ${event.filteredReports.length} items');

      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        print(
            '📊 Current state: ${current.reports.length} reports, ${current.filteredReports.length} filtered');
        print(
            '🔄 Updating filtered reports to: ${event.filteredReports.length} items');

        final newState = current.copyWith(
          filteredReports: event.filteredReports,
          currentPage: 1, // รีเซ็ตไปหน้าแรก
        );

        emit(newState);
        print('✅ UpdateFilteredReportsEvent completed');
      } else {
        print('❌ UpdateFilteredReportsEvent: State is not ReportLoaded');
      }
    });

// แก้ไขส่วน LoadReportsEvent
    on<LoadReportsEvent>((event, emit) async {
      print('🟡 LoadReportsEvent triggered');
      emit(ReportLoading());

      try {
        print('🟡 Calling repository.fetchReports()...');
        final result = await repository.fetchReports();
        final reports = result.reports;
        final meta = result.meta;

        print('✅ Repository returned: ${reports.length} reports');
        print(
            '📊 Meta: page=${meta.page}, size=${meta.size}, total=${meta.total}');

        if (reports.isEmpty) {
          print('⚠️ Warning: No reports found in data');
        } else {
          print(
              '📄 Sample report: ${reports.first.docDate} - ${reports.first.totalAmount}');
        }
        emit(ReportLoaded(
          reports,
          allReports: reports, // สำคัญ: ต้องส่ง allReports ด้วย
          currentPage: meta.page,
          itemsPerPage: meta.size,
          selectedIndexes: {0, 1, 2, 3, 4, 5, 6, 7, 8}, // เปิดทุกคอลัมน์
        ));
        print('✅ ReportLoaded state emitted successfully');
      } catch (e, stack) {
        print('❌ LoadReportsEvent ERROR: $e');
        print('📛 STACK: $stack');
        emit(ReportError('Failed to load reports: $e'));
      }
    });

    on<FilterReportsEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        final filtered = current.reports.where((item) {
          final date = item.docDate;
          final matchMonth = event.month == null || date.month == event.month;
          final matchYear = event.year == null || date.year == event.year;
          return matchMonth && matchYear;
        }).toList();

        emit(ReportLoaded(current.reports, filtered: filtered));
      }
    });
    on<SetStepEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(currentStep: event.currentStep));
      }
    });
    // แก้ไข SetDateRangeEvent
    on<SetDateRangeEvent>((event, emit) {
      print('📅 SetDateRangeEvent: ${event.startDate} to ${event.endDate}');

      if (state is ReportLoaded) {
        final current = state as ReportLoaded;

        final newState = current.copyWith(
          startDate: event.startDate,
          endDate: event.endDate,
        );

        emit(newState);
        print('✅ Date range updated in state');
      } else {
        print('❌ SetDateRangeEvent: State is not ReportLoaded');
      }
    });

    on<SelectReportType>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedReportType: event.reportType));
      }
    });
    on<UpdateCardDataEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        // สร้าง newCardData โดยคัดลอกข้อมูลเดิม
        final newCardData = Map<int, dynamic>.from(current.cardData);
        // อัพเดทข้อมูลสำหรับ step ที่ระบุ
        newCardData[event.stepIndex] = event.data;

        emit(current.copyWith(
          cardData: newCardData,
        ));
      }
    });
    on<ToggleInStockFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        List<Data> filtered = current.allReports;
        filtered =
            filtered.where((item) => item == current.productSelected).toList();
        if (event.showOnlyInStock) {
          filtered = filtered.where((item) => item.totalAmount > 0).toList();
        }
        emit(current.copyWith(
          showOnlyInStock: event.showOnlyInStock,
          filteredReports: filtered,
        ));
      }
    });

    on<ApplyFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: event.selectedIndexes));
      }
    });

    on<ClearFilterEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: {}));
      }
    });

    on<ResetFilterToDefaultEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(selectedIndexes: {0, 2})); // ตัวอย่าง default
      }
    });

    on<ChangePageEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(current.copyWith(currentPage: event.page));
      }
    });

    on<ChangeItemsPerPageEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        emit(
            current.copyWith(currentPage: 1, itemsPerPage: event.itemsPerPage));
      }
    });



    /* on<ProductSelectedEvent>((event, emit) {
      if (state is ReportLoaded) {
        final current = state as ReportLoaded;
        List<data> filtered = current.allReports;
        if (event.productSelected != null) {
          filtered =
              filtered.where((item) => item == event.productSelected).toList();
        }
        if (current.showOnlyInStock) {
          filtered = filtered.where((item) => item.totalAmount > 0).toList();
        }
        emit(current.copyWith(
          productSelected: event.productSelected,
          filteredReports: filtered,
        ));
      }
    });*/
  }
}
