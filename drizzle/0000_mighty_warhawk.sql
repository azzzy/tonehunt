-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
DO $$ BEGIN
 CREATE TYPE "key_status" AS ENUM('expired', 'invalid', 'valid', 'default');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "key_type" AS ENUM('stream_xchacha20', 'secretstream', 'secretbox', 'kdf', 'generichash', 'shorthash', 'auth', 'hmacsha256', 'hmacsha512', 'aead-det', 'aead-ietf');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "request_status" AS ENUM('ERROR', 'SUCCESS', 'PENDING');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_type" AS ENUM('webauthn', 'totp');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "factor_status" AS ENUM('verified', 'unverified');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "aal_level" AS ENUM('aal3', 'aal2', 'aal1');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 CREATE TYPE "code_challenge_method" AS ENUM('plain', 's256');
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "_prisma_migrations" (
	"id" varchar(36) PRIMARY KEY NOT NULL,
	"checksum" varchar(64) NOT NULL,
	"finished_at" timestamp with time zone,
	"migration_name" varchar(255) NOT NULL,
	"logs" text,
	"rolled_back_at" timestamp with time zone,
	"started_at" timestamp with time zone DEFAULT now() NOT NULL,
	"applied_steps_count" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Profile" (
	"id" text PRIMARY KEY NOT NULL,
	"username" varchar(36),
	"firstname" varchar(255),
	"lastname" varchar(255),
	"avatar" varchar(255),
	"bio" text,
	"active" boolean DEFAULT true NOT NULL,
	"licenseId" integer,
	"socials" jsonb
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Favorite" (
	"id" serial PRIMARY KEY NOT NULL,
	"modelId" text NOT NULL,
	"profileId" text NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Model" (
	"id" text PRIMARY KEY NOT NULL,
	"title" varchar(255) NOT NULL,
	"description" text,
	"ampName" varchar(255),
	"modelPath" varchar(255),
	"filename" varchar(255),
	"icon" varchar(255),
	"profileId" text NOT NULL,
	"private" boolean DEFAULT false NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"categoryId" integer NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL,
	"link" varchar(255),
	"tags" text[],
	"filecount" integer,
	"licenseId" integer
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Category" (
	"id" serial PRIMARY KEY NOT NULL,
	"title" varchar(255) NOT NULL,
	"slug" varchar(255) NOT NULL,
	"icon" varchar(255),
	"order" integer NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL,
	"pluralTitle" varchar(255),
	"sort" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Tag" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"group" varchar(255),
	"active" boolean DEFAULT true NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Counts" (
	"name" varchar(255) PRIMARY KEY NOT NULL,
	"count" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "ModelDownload" (
	"id" text PRIMARY KEY NOT NULL,
	"modelId" text NOT NULL,
	"profileId" text,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "Follow" (
	"id" serial PRIMARY KEY NOT NULL,
	"profileId" text NOT NULL,
	"targetId" text NOT NULL,
	"active" boolean DEFAULT true NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE IF NOT EXISTS "License" (
	"id" serial PRIMARY KEY NOT NULL,
	"name" varchar(255) NOT NULL,
	"description" text,
	"active" boolean DEFAULT true NOT NULL,
	"createdAt" timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"updatedAt" timestamp(3) with time zone NOT NULL,
	"deleted" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Profile_username_key" ON "Profile" ("username");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Category_order_key" ON "Category" ("order");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "Counts_name_idx" ON "Counts" ("name");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Counts_name_key" ON "Counts" ("name");--> statement-breakpoint
CREATE INDEX IF NOT EXISTS "ModelDownload_id_idx" ON "ModelDownload" ("id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "ModelDownload_id_key" ON "ModelDownload" ("id");--> statement-breakpoint
CREATE UNIQUE INDEX IF NOT EXISTS "Follow_profileId_targetId_key" ON "Follow" ("profileId","targetId");--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Profile" ADD CONSTRAINT "Profile_licenseId_fkey" FOREIGN KEY ("licenseId") REFERENCES "public"."License"("id") ON DELETE set null ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_modelId_fkey" FOREIGN KEY ("modelId") REFERENCES "public"."Model"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Favorite" ADD CONSTRAINT "Favorite_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "public"."Profile"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Model" ADD CONSTRAINT "Model_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "public"."Category"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Model" ADD CONSTRAINT "Model_licenseId_fkey" FOREIGN KEY ("licenseId") REFERENCES "public"."License"("id") ON DELETE set null ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Model" ADD CONSTRAINT "Model_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "public"."Profile"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ModelDownload" ADD CONSTRAINT "ModelDownload_modelId_fkey" FOREIGN KEY ("modelId") REFERENCES "public"."Model"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "ModelDownload" ADD CONSTRAINT "ModelDownload_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "public"."Profile"("id") ON DELETE set null ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Follow" ADD CONSTRAINT "Follow_profileId_fkey" FOREIGN KEY ("profileId") REFERENCES "public"."Profile"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;
--> statement-breakpoint
DO $$ BEGIN
 ALTER TABLE "Follow" ADD CONSTRAINT "Follow_targetId_fkey" FOREIGN KEY ("targetId") REFERENCES "public"."Profile"("id") ON DELETE restrict ON UPDATE cascade;
EXCEPTION
 WHEN duplicate_object THEN null;
END $$;

*/