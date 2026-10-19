module api.user.post;

import vibe.vibe;
import std.ascii : isAlpha;
import std.algorithm : all;

struct UserRequest {
  string name;
  string[] wishlist;
}

struct UserResponse {
  bool success;
  string message;
}

void handle (HTTPServerRequest req, HTTPServerResponse res) {
  if (req.contentType != "application/json") {
    res.statusCode = HTTPStatus.badRequest;

    res.writeJsonBody([
      "error": "Content-Type must be application/json"
    ]);

    return;
  }

  try {
    if ("name" !in req.json) {
      res.statusCode = HTTPStatus.badRequest;

      res.writeJsonBody([
        "error": "Missing name."
      ]);

      return;
    }

    if ("wishlist" !in req.json) {
      res.statusCode = HTTPStatus.badRequest;

      res.writeJsonBody([
        "error": "Missing wishlist."
      ]);

      return;
    }

    auto userData = deserializeJson!UserRequest(req.json);

    if (userData.name.length < 1 || userData.name.length > 100) {
      res.statusCode = HTTPStatus.badRequest;

      res.writeJsonBody([
        "error": "Invalid name length."
      ]);

      return;
    }

    bool isValidName = userData.name.all!(c => isAlpha(c) || c == '-' || c == '\'');

    if (!isValidName) {
      res.statusCode = HTTPStatus.badRequest;

      res.writeJsonBody([
        "error": "Invalid name."
      ]);

      return;
    }

    logInfo("Received user: %s with %d wishlist items", userData.name, userData.wishlist.length);

    auto responseData = UserResponse(true, "Wishlist received!");

    res.writeJsonBody(responseData);

  } catch (Exception e) {
    res.statusCode = HTTPStatus.badRequest;
    res.writeJsonBody(["error": "Malformed JSON payload: " ~ e.msg]);
  }
}
