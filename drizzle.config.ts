import type { Config } from "drizzle-kit";
import * as process from "process";
export default {
  dbCredentials: {
    connectionString: process.env.DATABASE_URL!,
  },
  driver: "pg",
  schema: "./schema.ts",
  out: "./drizzle",
} satisfies Config;
