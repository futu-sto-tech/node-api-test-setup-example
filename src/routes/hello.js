/**
 * Registers /hello route
 * @param {FastifyInstance} fastify Fastify instance
 * @param {Object} options Plugin options
 */
const routes = async (fastify, _options) => {
  fastify.get(
    "/hello",
    {
      schema: {
        querystring: {
          name: { type: "string" },
        },
      },
    },
    async (request, _reply) => {
      const name = request.query.name || "world";

      return { hello: name };
    }
  );
};

export default routes;
