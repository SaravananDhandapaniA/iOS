//
//  Provider.swift
//  MovieWidgetExtension
//
//  Created by Tringapps on 17/07/23.
//

import WidgetKit

struct Provider: TimelineProvider {
    
    typealias Entry = MovieEntry
    
    func placeholder(in context: Context) -> MovieEntry {
        MovieEntry.mockMovieEntry()
    }

    func getSnapshot(in context: Context, completion: @escaping (MovieEntry) -> ()) {
        let entry = MovieEntry.mockMovieEntry()
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = MovieEntry.mockMovieEntry()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 60, to: currentDate)
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate ?? .distantFuture))
        completion(timeline)
    }
}
