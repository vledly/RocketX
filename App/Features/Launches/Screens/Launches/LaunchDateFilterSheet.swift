import SwiftUI

struct LaunchDateFilterSheet: View {
    private enum DateField: Equatable {
        case start
        case end
    }

    @Environment(\.dismiss) private var dismiss
    @State private var startDate: Date?
    @State private var endDate: Date?
    @State private var calendarDate: Date
    @State private var editingField: DateField?

    private let suggestedDate: Date
    let onApply: (LaunchDateRange) -> Void

    init(
        range: LaunchDateRange,
        suggestedDate: Date,
        onApply: @escaping (LaunchDateRange) -> Void
    ) {
        _startDate = State(initialValue: range.start)
        _endDate = State(initialValue: range.end)
        _calendarDate = State(initialValue: suggestedDate)
        self.suggestedDate = suggestedDate
        self.onApply = onApply
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                DateInput(
                    title: .launchesFilterFrom,
                    date: $startDate,
                    field: .start,
                    suggestedDate: suggestedDate,
                    calendarDate: $calendarDate,
                    editingField: $editingField
                )
                DateInput(
                    title: .launchesFilterTo,
                    date: $endDate,
                    field: .end,
                    suggestedDate: suggestedDate,
                    calendarDate: $calendarDate,
                    editingField: $editingField
                )

                if !draftRange.isValid {
                    Text(.launchesFilterInvalidRange)
                        .font(.footnote)
                        .foregroundStyle(.red)
                }

                Spacer(minLength: 0)

                HStack(spacing: 12) {
                    Button(.launchesFilterClear) {
                        onApply(.all)
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button(.launchesFilterApply) {
                        onApply(draftRange)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(!draftRange.isValid)
                    .frame(maxWidth: .infinity)
                }
                .controlSize(.large)
            }
            .padding(20)
            .navigationTitle(.launchesFilterTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(.commonClose) { dismiss() }
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }

    private var draftRange: LaunchDateRange {
        LaunchDateRange(start: startDate, end: endDate)
    }

    private struct DateInput: View {
        let title: LocalizedStringResource
        @Binding var date: Date?
        let field: DateField
        let suggestedDate: Date
        @Binding var calendarDate: Date
        @Binding var editingField: DateField?

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(.medium))

                HStack(spacing: 12) {
                    Button {
                        calendarDate = date ?? suggestedDate
                        editingField = field
                    } label: {
                        HStack {
                            Text(date?.formatted(date: .abbreviated, time: .omitted)
                                 ?? String(localized: .launchesFilterSelectDate))
                                .foregroundStyle(date == nil ? Color.secondary : Color.primary)
                            Spacer()
                            Image(systemName: AppIcons.calendar)
                                .foregroundStyle(.secondary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .popover(isPresented: Binding(
                        get: { editingField == field },
                        set: { if !$0 { editingField = nil } }
                    )) {
                        VStack(spacing: 12) {
                            DatePicker(
                                .launchesFilterSelectDate,
                                selection: $calendarDate,
                                displayedComponents: .date
                            )
                            .datePickerStyle(.graphical)

                            Button(.launchesFilterUseDate) {
                                select(calendarDate)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(12)
                        .frame(width: 320)
                        .presentationCompactAdaptation(.popover)
                    }

                    if date != nil {
                        Button {
                            date = nil
                            editingField = nil
                        } label: {
                            Image(systemName: AppIcons.clearDate)
                                .foregroundStyle(.secondary)
                        }
                        .accessibilityLabel(.launchesFilterClearDate)
                    }
                }
                .padding(14)
                .background(.quaternary.opacity(0.35), in: RoundedRectangle(cornerRadius: 12))
            }
        }

        private func select(_ selectedDate: Date) {
            date = selectedDate
            editingField = nil
        }
    }
}
