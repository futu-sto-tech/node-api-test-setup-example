import fastify from "fastify";

export const buildApp = (opts = {}) => {
  const app = fastify(opts);

  app.register(import("./routes/hello.js"));

  return app;
};
