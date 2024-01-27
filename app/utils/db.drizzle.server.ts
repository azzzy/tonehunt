import type { NodePgDatabase } from "drizzle-orm/node-postgres";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import * as process from "process";
import config from "../../drizzle.config";
import * as schema from './../../drizzle/schema';

let db: NodePgDatabase<typeof schema>;

declare global {
  var __drizzleDb: NodePgDatabase<typeof schema>;
}

// this is needed because in development we don't want to restart
// the server with every change, but we want to make sure we don't
// create a new connection to the DB with every change either.
if (process.env.NODE_ENV === "production") {
  const client = new Pool(config.dbCredentials);
  db = drizzle(client);
} else {
  if (!global.__drizzleDb) {
    const client = new Pool(config.dbCredentials);
    global.__drizzleDb = drizzle(client, { schema });
  }
  db = global.__drizzleDb;
}

export { db };
