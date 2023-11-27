//
//  MovieWidget.swift
//  MovieWidget
//
//  Created by Tringapps on 17/07/23.
//

import WidgetKit
import SwiftUI


struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct MovieWidgetEntryView : View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family
    
    @ViewBuilder
    var body: some View {
        switch family {
        case .systemSmall:
            MovieSmallWidget(entry: entry)
        default:
            MovieSmallWidget(entry: entry)
        }
    }
}

struct MovieWidget: Widget {
    let kind: String = "MovieWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MovieWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Movie Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//struct MovieWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieWidgetEntryView(entry: MovieEntry.mockMovieEntry())
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
