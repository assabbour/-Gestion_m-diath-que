import Vapor
import Fluent

final class Book: Model, Content, @unchecked Sendable {

    static let schema = "books"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "year")
    var year: Int

    @Field(key: "pages")
    var pages: Int

    @Parent(key: "author_id")
    var author: Author

    @Siblings(
        through: BookGenre.self,
        from: \.$book,
        to: \.$genre
    )
    var genres: [Genre]

    init() {}

    init(
        id: UUID? = nil,
        title: String,
        year: Int,
        pages: Int,
        authorID: UUID
    ) {
        self.id = id
        self.title = title
        self.year = year
        self.pages = pages
        self.$author.id = authorID
    }
}
