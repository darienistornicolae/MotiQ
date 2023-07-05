//
//  QuotesWidgetView.swift
//  MotiqWidgetExtension
//
//  Created by Darie-Nistor Nicolae on 05.07.2023.
//

import WidgetKit
import SwiftUI
import Intents

struct MotiqWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}
