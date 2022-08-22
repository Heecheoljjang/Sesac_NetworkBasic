//
//  RealmModel.swift
//  Sesac_NetworkBasic
//
//  Created by HeecheolYoon on 2022/08/22.
//

import Foundation

import RealmSwift

class Movie: EmbeddedObject {
    @Persisted var rank: String
    @Persisted var movieTitle: String
    @Persisted var releaseDate: String
    @Persisted var totalCount: String
    
    convenience init(rank: String, movieTitle: String, releaseDate: String, totalCount: String) {
        self.init()
        self.rank = rank
        self.movieTitle = movieTitle
        self.releaseDate = releaseDate
        self.totalCount = totalCount
    }
}

class MovieData: Object {
    
    @Persisted var boxofficeList = List<Movie>()
   
    @Persisted(primaryKey: true) var objectID: String
    
    convenience init(boxofficeList: List<Movie>, objectId: String) {
        self.init()
        self.boxofficeList = boxofficeList

        self.objectID = objectId
    }
}

