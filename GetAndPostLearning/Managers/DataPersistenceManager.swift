//
//  DataPersistenceManager.swift
//  GetAndPostLearning
//
//  Created by Tringapps on 26/06/23.
//

import Foundation
import UIKit
import CoreData

enum DatabaseError: Error {
    case failedToSaveDataInCoreData
    case failedToFetchDataInCoreData
    case failedToDeleteDataInCoreData
}

class DataPersistenceManager {
    
    static let shared = DataPersistenceManager()
    
    func fetchUserSignupData(completion: @escaping (Result<[Register], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Register>
        request = Register.fetchRequest()
        
        do {
            let data = try context.fetch(request)
            completion(.success(data))
        } catch {
            completion(.failure(DatabaseError.failedToFetchDataInCoreData))
        }
    }
    
    func downloadMovieWith(model: Title , completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let item = DownloadMovies(context: context)
        item.id = Int64(model.id)
        item.media_type = model.media_type
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.release_date = model.release_date
        item.vote_average = model.vote_average
        item.vote_count = Int64(model.vote_count)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveDataInCoreData))
        }
    }
    
    func fetchingMoviesFromDatabase(completion: @escaping(Result<[DownloadMovies], Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<DownloadMovies>
        request = DownloadMovies.fetchRequest()
        
        do {
            let data = try context.fetch(request)
            completion(.success(data))
        } catch {
            completion(.failure(DatabaseError.failedToFetchDataInCoreData))
        }
    }
    
    func deleteMovieWith(model: DownloadMovies , completion: @escaping (Result<Void, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteDataInCoreData))
        }
    }
    
    func fetchMovieWithId(with id: Int, completion: @escaping(Result<DownloadMovies?, Error>) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            completion(.failure(DatabaseError.failedToFetchDataInCoreData))
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<DownloadMovies>
        request = DownloadMovies.fetchRequest()
        request.predicate = NSPredicate(format: "id == %ld", Int64(id))
        
        do {
            let result = try context.fetch(request)
            if let downloadedMovie = result.first {
                completion(.success(downloadedMovie))
            } else {
                completion(.failure(DatabaseError.failedToFetchDataInCoreData))
            }
        } catch {
            completion(.failure(DatabaseError.failedToFetchDataInCoreData))
        }
    }
}
