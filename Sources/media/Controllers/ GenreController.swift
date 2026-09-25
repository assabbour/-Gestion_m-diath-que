//
//   GenreController.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Vapor
import Fluent

struct GenreController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {

        let genres = routes.grouped("genres")

        genres.get(use: index)
        genres.post(use: create)
        genres.get(":id", "books", use: books)
    }

    // GET /genres
    func index(req: Request) async throws -> [Genre] {
        try await Genre.query(on: req.db).all()
    }

    // POST /genres
    func create(req: Request) async throws -> Genre {

        let genre = try req.content.decode(Genre.self)

        try await genre.save(on: req.db)

        return genre
    }

    // GET /genres/:id/books
    func books(req: Request) async throws -> [Book] {

        guard let genre = try await Genre.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        return try await genre.$books.get(on: req.db)
    }
}
