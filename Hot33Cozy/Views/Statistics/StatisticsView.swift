import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundMain
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        
                        periodSelector
                        
                        if !viewModel.chartData.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Ritual Count")
                                    .font(.h2SectionTitle)
                                    .foregroundColor(.textPrimary)
                                    .padding(.horizontal, 16)
                                
                                Chart(viewModel.chartData) { dataPoint in
                                    BarMark(
                                        x: .value("Time", dataPoint.label),
                                        y: .value("Count", dataPoint.count)
                                    )
                                    .foregroundStyle(Color.primaryRed)
                                    .cornerRadius(4)
                                }
                                .frame(height: 200)
                                .chartXAxis {
                                    AxisMarks(values: .automatic) { value in
                                        if viewModel.selectedPeriod == .day {
                                            if let label = value.as(String.self),
                                               let hour = Int(label.components(separatedBy: ":").first ?? ""),
                                               hour % 3 == 0 {
                                                AxisValueLabel {
                                                    Text(label)
                                                        .font(.bodySecondary)
                                                        .foregroundColor(.textSecondary)
                                                }
                                            }
                                        } else {
                                            AxisValueLabel {
                                                if let label = value.as(String.self) {
                                                    Text(label)
                                                        .font(.bodySecondary)
                                                        .foregroundColor(.textSecondary)
                                                }
                                            }
                                        }
                                    }
                                }
                                .chartYAxis {
                                    AxisMarks { value in
                                        AxisValueLabel {
                                            if let count = value.as(Int.self) {
                                                Text("\(count)")
                                                    .font(.bodySecondary)
                                                    .foregroundColor(.textSecondary)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                            }
                            .padding(.vertical, 8)
                            .background(.thinMaterial)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        
                        if !viewModel.detailedRituals.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Details")
                                    .font(.h2SectionTitle)
                                    .foregroundColor(.textPrimary)
                                    .padding(.horizontal, 16)
                                
                                ForEach(viewModel.detailedRituals, id: \.0) { section, rituals in
                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Text(section)
                                                .font(.h3CardTitle)
                                                .foregroundColor(.textPrimary)
                                            
                                            Spacer()
                                            
                                            Text("\(rituals.count)")
                                                .font(.bodySecondary)
                                                .foregroundColor(.accentYellow)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 4)
                                                .background(Color.backgroundEmphasis)
                                                .cornerRadius(12)
                                        }
                                        
                                        ForEach(rituals) { ritual in
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(ritual.title)
                                                        .font(.bodyPrimary)
                                                        .foregroundColor(.textSecondary)
                                                    
                                                    if let notes = ritual.notes, !notes.isEmpty {
                                                        Text(notes)
                                                            .font(.bodySecondary)
                                                            .foregroundColor(.textMuted)
                                                            .lineLimit(1)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Text(ritual.date, style: .time)
                                                    .font(.bodySecondary)
                                                    .foregroundColor(.textMuted)
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            EmptyStateView(
                                icon: "chart.bar",
                                title: "No Data",
                                message: "Start tracking rituals to see your statistics."
                            )
                            .padding(.top, 40)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
    
    var periodSelector: some View {
        HStack(spacing: 0) {
            ForEach(TimePeriod.allCases, id: \.self) { period in
                let isSelected = viewModel.selectedPeriod == period
                
                Button {
                    guard !isSelected else { return }
                    viewModel.selectedPeriod = period
                    viewModel.loadData()
                } label: {
                    Text(period.rawValue)
                        .font(.buttonLabel)
                        .foregroundColor(isSelected ? .textPrimary : .textSecondary)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(
                            Group {
                                if isSelected {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.primaryRed)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                                .stroke(Color.green, lineWidth: 1)
                                        )
                                } else {
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.clear)
                                }
                            }
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.backgroundSurface)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.primaryRed, lineWidth: 1)
                )
        )
        .padding(.horizontal, 40)
    }
}

#Preview {
    StatisticsView()
}

