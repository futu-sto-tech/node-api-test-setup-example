import fastify from "fastify";

export const buildApp = (opts = {}) => {
  const app = fastify(opts);

  app.register(import("./features/hello/routes.js"), { prefix: "hello" });

  return app;
};
