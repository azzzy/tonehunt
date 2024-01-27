import { pgTable, pgEnum, varchar, timestamp, text, integer, uniqueIndex, foreignKey, boolean, jsonb, serial, index } from "drizzle-orm/pg-core"
import { relations, sql } from "drizzle-orm";

export const keyStatus = pgEnum("key_status", ['expired', 'invalid', 'valid', 'default'])
export const keyType = pgEnum("key_type", ['stream_xchacha20', 'secretstream', 'secretbox', 'kdf', 'generichash', 'shorthash', 'auth', 'hmacsha256', 'hmacsha512', 'aead-det', 'aead-ietf'])
export const requestStatus = pgEnum("request_status", ['ERROR', 'SUCCESS', 'PENDING'])
export const factorType = pgEnum("factor_type", ['webauthn', 'totp'])
export const factorStatus = pgEnum("factor_status", ['verified', 'unverified'])
export const aalLevel = pgEnum("aal_level", ['aal3', 'aal2', 'aal1'])
export const codeChallengeMethod = pgEnum("code_challenge_method", ['plain', 's256'])

export const profile = pgTable("Profile", {
	id: text("id").primaryKey().notNull(),
	username: varchar("username", { length: 36 }),
	firstname: varchar("firstname", { length: 255 }),
	lastname: varchar("lastname", { length: 255 }),
	avatar: varchar("avatar", { length: 255 }),
	bio: text("bio"),
	active: boolean("active").default(true).notNull(),
	licenseId: integer("licenseId").references(() => license.id, { onDelete: "set null", onUpdate: "cascade" } ),
	socials: jsonb("socials"),
},
(table) => {
	return {
		usernameKey: uniqueIndex("Profile_username_key").on(table.username),
	}
});

export const favorite = pgTable("Favorite", {
	id: serial("id").primaryKey().notNull(),
	modelId: text("modelId").notNull().references(() => model.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	profileId: text("profileId").notNull().references(() => profile.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
});

export const model = pgTable("Model", {
	id: text("id").primaryKey().notNull(),
	title: varchar("title", { length: 255 }).notNull(),
	description: text("description"),
	ampName: varchar("ampName", { length: 255 }),
	modelPath: varchar("modelPath", { length: 255 }),
	filename: varchar("filename", { length: 255 }),
	icon: varchar("icon", { length: 255 }),
	profileId: text("profileId").notNull().references(() => profile.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	private: boolean("private").default(false).notNull(),
	active: boolean("active").default(true).notNull(),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	categoryId: integer("categoryId").notNull().references(() => category.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	deleted: boolean("deleted").default(false).notNull(),
	link: varchar("link", { length: 255 }),
	tags: text("tags").array(),
	filecount: integer("filecount"),
	licenseId: integer("licenseId").references(() => license.id, { onDelete: "set null", onUpdate: "cascade" } ),
});

export const _modelRelations = relations(model, ({one, many}) => ({
	profile: one(profile),
	category: one(category),
	favorites: many(favorite),
	downloads: many(modelDownload),
	license: one(license),
}));

export const category = pgTable("Category", {
	id: serial("id").primaryKey().notNull(),
	title: varchar("title", { length: 255 }).notNull(),
	slug: varchar("slug", { length: 255 }).notNull(),
	icon: varchar("icon", { length: 255 }),
	order: integer("order").notNull(),
	active: boolean("active").default(true).notNull(),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
	pluralTitle: varchar("pluralTitle", { length: 255 }),
	sort: integer("sort").default(0).notNull(),
},
(table) => {
	return {
		orderKey: uniqueIndex("Category_order_key").on(table.order),
	}
});

export const tag = pgTable("Tag", {
	id: serial("id").primaryKey().notNull(),
	name: varchar("name", { length: 255 }).notNull(),
	group: varchar("group", { length: 255 }),
	active: boolean("active").default(true).notNull(),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
});

export const counts = pgTable("Counts", {
	name: varchar("name", { length: 255 }).primaryKey().notNull(),
	count: integer("count").notNull(),
},
(table) => {
	return {
		nameIdx: index("Counts_name_idx").on(table.name),
		nameKey: uniqueIndex("Counts_name_key").on(table.name),
	}
});

export const modelDownload = pgTable("ModelDownload", {
	id: text("id").primaryKey().notNull(),
	modelId: text("modelId").notNull().references(() => model.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	profileId: text("profileId").references(() => profile.id, { onDelete: "set null", onUpdate: "cascade" } ),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
},
(table) => {
	return {
		idIdx: index("ModelDownload_id_idx").on(table.id),
		idKey: uniqueIndex("ModelDownload_id_key").on(table.id),
	}
});

export const follow = pgTable("Follow", {
	id: serial("id").primaryKey().notNull(),
	profileId: text("profileId").notNull().references(() => profile.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	targetId: text("targetId").notNull().references(() => profile.id, { onDelete: "restrict", onUpdate: "cascade" } ),
	active: boolean("active").default(true).notNull(),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
},
(table) => {
	return {
		profileIdTargetIdKey: uniqueIndex("Follow_profileId_targetId_key").on(table.profileId, table.targetId),
	}
});

export const license = pgTable("License", {
	id: serial("id").primaryKey().notNull(),
	name: varchar("name", { length: 255 }).notNull(),
	description: text("description"),
	active: boolean("active").default(true).notNull(),
	createdAt: timestamp("createdAt", { precision: 3, withTimezone: true, mode: 'string' }).defaultNow().notNull(),
	updatedAt: timestamp("updatedAt", { precision: 3, withTimezone: true, mode: 'string' }).notNull(),
	deleted: boolean("deleted").default(false).notNull(),
});
