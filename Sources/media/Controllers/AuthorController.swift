//
//  AuthorController.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Vapor
import Fluent

struct AuthorController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {

        let authors = routes.grouped("authors")

        authors.get(use: index)
        authors.post(use: create)
        authors.get(":id", use: show)
        authors.get(":id", "books", use: books)
    }

    // GET /authors
    func index(req: Request) async throws -> [Author] {
        try await Author.query(on: req.db).all()
    }

    // POST /authors
    func create(req: Request) async throws -> Author {
        let author = try req.content.decode(Author.self)

        try await author.save(on: req.db)

        return author
    }

    // GET /authors/:id
    func show(req: Request) async throws -> Author {

        guard let author = try await Author.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        return author
    }

    // GET /authors/:id/books
    func books(req: Request) async throws -> [Book] {

        guard let author = try await Author.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        return try await author.$books.get(on: req.db)
    }
}
