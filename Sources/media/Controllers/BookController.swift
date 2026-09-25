//
//  BookController.swift
//  media
//
//  Created by apprenant 108 on 25/09/2026.
//

import Vapor
import Fluent

struct BookController: RouteCollection {

    func boot(routes: any RoutesBuilder) throws {

        let books = routes.grouped("books")

        // CRUD
        books.get(use: index)
        books.post(use: create)
        books.get(":id", use: show)
        books.put(":id", use: update)
        books.delete(":id", use: delete)

        // Relations avec Genre
        books.get(":id", "genres", use: genres)
        books.post(":id", "genres", ":genreID", use: addGenre)
        books.delete(":id", "genres", ":genreID", use: removeGenre)
    }

    // GET /books
    func index(req: Request) async throws -> [Book] {
        try await Book.query(on: req.db).all()
    }

    // POST /books
    func create(req: Request) async throws -> Book {
        let book = try req.content.decode(Book.self)

        try await book.save(on: req.db)

        return book
    }

    // GET /books/:id
    func show(req: Request) async throws -> Book {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        return book
    }

    // PUT /books/:id
    func update(req: Request) async throws -> Book {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        let data = try req.content.decode(Book.self)

        book.title = data.title
        book.year = data.year
        book.pages = data.pages
        book.$author.id = data.$author.id

        try await book.save(on: req.db)

        return book
    }

    // DELETE /books/:id
    func delete(req: Request) async throws -> HTTPStatus {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        try await book.delete(on: req.db)

        return .noContent
    }

    // GET /books/:id/genres
    func genres(req: Request) async throws -> [Genre] {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        return try await book.$genres.get(on: req.db)
    }

    // POST /books/:id/genres/:genreID
    func addGenre(req: Request) async throws -> HTTPStatus {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        guard let genre = try await Genre.find(
            req.parameters.get("genreID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        try await book.$genres.attach(genre, on: req.db)

        return .created
    }

    // DELETE /books/:id/genres/:genreID
    func removeGenre(req: Request) async throws -> HTTPStatus {

        guard let book = try await Book.find(
            req.parameters.get("id"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        guard let genre = try await Genre.find(
            req.parameters.get("genreID"),
            on: req.db
        ) else {
            throw Abort(.notFound)
        }

        try await book.$genres.detach(genre, on: req.db)

        return .noContent
    }
}
