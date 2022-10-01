import { v4 as uuidv4 } from "uuid";
import { buildApp } from "./app.js";

process.on("SIGINT", () => process.exit(0));
process.on("SIGTERM", () => process.exit(0));

const start = async () => {
  const app = buildApp({
    logger: {
      logLevel: "info",
    },
    genReqId: uuidv4,
  });
  try {
    app.listen({ port: 8080 });
  } catch (err) {
    app.log.error(err);
    process.exit(1);
  }
};
start();
