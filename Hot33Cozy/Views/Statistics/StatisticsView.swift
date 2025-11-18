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
                        Picker("Period", selection: $viewModel.selectedPeriod) {
                            ForEach(TimePeriod.allCases, id: \.self) { period in
                                Text(period.rawValue).tag(period)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal, 16)
                        .colorScheme(.dark)
                        .onChange(of: viewModel.selectedPeriod) { _, _ in
                            viewModel.loadData()
                        }
                        
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
                            .padding(.vertical, 16)
                            .background(Color.backgroundSurface)
                            .cornerRadius(10)
                            .padding(.horizontal, 16)
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
                                    .padding(16)
                                    .background(Color.backgroundSurface)
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal, 16)
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
                    .padding(.vertical, 16)
                }
            }
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadData()
            }
        }
    }
}

#Preview {
    StatisticsView()
}

