module api.books.get;

import vibe.vibe;

struct Book {
  string name;
  string author;
}

struct BooksResponse {
  Book[] books;
}

void handle (HTTPServerRequest req, HTTPServerResponse res) {
  Book[] bookList = [
    Book("Alice in Wonderland", "Lewis Carroll"),
    Book("The Fellowship of the Ring", "J.R.R. Tolkien")
  ];

  res.writeJsonBody(
    BooksResponse(bookList)
  );
}
