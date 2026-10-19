module app;

import vibe.vibe;
import api.user.post;
import api.books.get;

void main () {
  auto router = new URLRouter;

  router
    .post("/user", &api.user.post.handle)
    .get("/books", &api.books.get.handle)
    .get("/", serveStaticFile("./source/public/index.html"))
    .get("*", serveStaticFiles("./source/public/"));

  auto settings = new HTTPServerSettings;

  settings.port = 4000;
  settings.bindAddresses = ["::1", "127.0.0.1"];

  listenHTTP(settings, router);
  runApplication();
}
