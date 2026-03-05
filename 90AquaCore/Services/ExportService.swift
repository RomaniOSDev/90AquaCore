//
//  ExportService.swift
//  90AquaCore
//

import Foundation
import UIKit

enum ExportFormat {
    case csv
    case pdf
}

enum ExportService {
    static func exportEntries(_ entries: [HydrationEntry], format: ExportFormat) -> URL? {
        switch format {
        case .csv: return exportCSV(entries)
        case .pdf: return exportPDF(entries)
        }
    }
    
    private static func exportCSV(_ entries: [HydrationEntry]) -> URL? {
        let header = "Date,Time,Amount (ml),Intensity,Note\n"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        let rows = entries.map { entry in
            let dateStr = dateFormatter.string(from: entry.date)
            let timeStr = timeFormatter.string(from: entry.date)
            let intensity = entry.workoutIntensity?.displayName ?? ""
            let note = (entry.note ?? "").replacingOccurrences(of: ",", with: ";")
            return "\(dateStr),\(timeStr),\(entry.amountML),\(intensity),\(note)"
        }
        let csv = header + rows.joined(separator: "\n")
        
        let filename = "aquacore_export_\(dateFormatter.string(from: Date())).csv"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? csv.write(to: url, atomically: true, encoding: .utf8)
        return url
    }
    
    private static func exportPDF(_ entries: [HydrationEntry]) -> URL? {
        let pdfMetaData = [kCGPDFContextCreator: "AquaCore"]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageWidth: CGFloat = 612
        let pageHeight: CGFloat = 792
        let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let data = renderer.pdfData { context in
            context.beginPage()
            var y: CGFloat = 40
            
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor(red: 0.08, green: 0.20, blue: 0.33, alpha: 1)
            ]
            "AquaCore - Hydration Export".draw(at: CGPoint(x: 40, y: y), withAttributes: titleAttributes)
            y += 40
            
            let headerAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 12),
                .foregroundColor: UIColor(red: 0.08, green: 0.20, blue: 0.33, alpha: 1)
            ]
            let bodyAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 10),
                .foregroundColor: UIColor.darkGray
            ]
            
            "Date | Time | Amount (ml) | Intensity | Note".draw(at: CGPoint(x: 40, y: y), withAttributes: headerAttributes)
            y += 25
            
            let total = entries.reduce(0) { $0 + $1.amountML }
            "Total entries: \(entries.count) | Total water: \(total) ml".draw(at: CGPoint(x: 40, y: y), withAttributes: bodyAttributes)
            y += 30
            
            for entry in entries.prefix(100) {
                if y > pageHeight - 60 {
                    context.beginPage()
                    y = 40
                }
                let line = "\(dateFormatter.string(from: entry.date)) | \(entry.amountML) ml | \(entry.workoutIntensity?.displayName ?? "-") | \(entry.note ?? "-")"
                line.draw(at: CGPoint(x: 40, y: y), withAttributes: bodyAttributes)
                y += 18
            }
        }
        
        let filename = "aquacore_export_\(DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none).replacingOccurrences(of: "/", with: "-")).pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
        try? data.write(to: url)
        return url
    }
}
