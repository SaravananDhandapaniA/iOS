//
//  MovieEntry.swift
//  MovieWidgetExtension
//
//  Created by Tringapps on 17/07/23.
//

import WidgetKit

struct MovieEntry: TimelineEntry {
    
    let date: Date
    let movie: [Title]
    
    static func mockMovieEntry() -> MovieEntry {
        let data = MovieEntry(date: Date(), movie: [Title(
                id: 298618,
                media_type: "movie",
                original_name: "The Flash",
                original_title: "The Flash",
                poster_path: "https://image.tmdb.org/t/p/w500/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg",
                overview: "When his attempt to save his family inadvertently alters the future, Barry Allen becomes trapped in a reality in which General Zod has returned and there are no Super Heroes to turn to. In order to save the world that he is in and return to the future that he knows, Barry's only hope is to race for his life. But will making the ultimate sacrifice be enough to reset the universe?",
                vote_count: 835,
                release_date: "2023-06-13",
                vote_average: 6.711)
        ]
        )
        return data
    }
}
