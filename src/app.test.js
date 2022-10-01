import test from "node:test";
import assert from "node:assert";
import { buildApp } from "./app.js";

test("API Tests", async (t) => {
  const app = buildApp({ logger: true });

  await t.test("The API says hello", async () => {
    const response = await app.inject().get("/hello").end();

    assert.strictEqual(response.statusCode, 200, "Successful status code");
    assert.deepEqual(response.json(), { hello: "world" });
  });

  await t.test("The API says hello to someone", async () => {
    const response = await app.inject().get("/hello?name=alice").end();

    assert.strictEqual(response.statusCode, 200, "Successful status code");
    assert.deepEqual(response.json(), { hello: "alice" });
  });
});
