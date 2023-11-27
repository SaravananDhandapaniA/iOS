//
//  MovieSmallWidget.swift
//  MovieWidgetExtension
//
//  Created by Tringapps on 17/07/23.
//

import SwiftUI
import WidgetKit

struct MovieSmallWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        if let movie = entry.movie.first {
            ZStack {
                if let bgImageName = movie.poster_path {
                    let image = UIImage(named: bgImageName)
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                }
                
                VStack(alignment: .leading, spacing: 10) {
                    Spacer()
                    
                    Text(movie.original_title ?? "Sara")
                        .foregroundColor(.white)
                        .background(Color.green)
                        .lineLimit(2)
                        .padding(.horizontal, 10)
                    
                    Text(movie.overview ?? "Sara")
                        .font(.system(.subheadline))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .padding(.horizontal, 10)
                }
                .background(Color(red: 0.09, green: 0.10, blue: 0.11, opacity: 0.6))
            }
        } else {
            Text("No movie data available.")
        }
    }
}

//struct MovieSmallWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        MovieSmallWidget(entry: Title(
//            id: 298618,
//            media_type: "movie",
//            original_name: "The Flash",
//            original_title: "The Flash",
//            poster_path: "/rktDFPbfHfUbArZ6OOOKsXcv0Bm.jpg",
//            overview: "When his attempt to save his family inadvertently alters the future, Barry Allen becomes trapped in a reality in which General Zod has returned and there are no Super Heroes to turn to. In order to save the world that he is in and return to the future that he knows, Barry's only hope is to race for his life. But will making the ultimate sacrifice be enough to reset the universe?",
//            vote_count: 835,
//            release_date: "2023-06-13",
//            vote_average: 6.711)
//    )
//        .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}
