//
//  MotiqWidget.swift
//  MotiqWidget
//
//  Created by Darie-Nistor Nicolae on 05.07.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct MotiqWidget: Widget {
    let kind: String = "MotiqWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            MotiqWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Medium Quotes")
        .description("You can see the quote and it's author, and also save it and share it!")
        .supportedFamilies([.systemMedium])
    }
}

struct MotiqWidget_Previews: PreviewProvider {
    static var previews: some View {
        MotiqWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
