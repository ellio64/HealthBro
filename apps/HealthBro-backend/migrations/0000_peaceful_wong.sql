CREATE TABLE `activity_types` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`user_id` integer NOT NULL,
	`name` text NOT NULL,
	`category` text NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `activity_types_user_id_name_unique` ON `activity_types` (`user_id`,`name`);--> statement-breakpoint
CREATE TABLE `days` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`user_id` integer NOT NULL,
	`date` text NOT NULL,
	`fruit_veg_servings` integer,
	`bowel_movements` integer,
	`water_ml` integer,
	`coffee_cups` integer,
	`steps` integer,
	`ate_fish` integer,
	`resting_pulse` integer,
	`bedtime` text,
	`wake_time` text,
	`sleep_hours` real,
	`sleep_score` integer,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "sleep_score_range" CHECK("days"."sleep_score" BETWEEN 0 AND 100)
);
--> statement-breakpoint
CREATE UNIQUE INDEX `days_user_id_date_unique` ON `days` (`user_id`,`date`);--> statement-breakpoint
CREATE TABLE `pain_episodes` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`day_id` integer NOT NULL,
	`intensity` integer NOT NULL,
	`body_area` text,
	`note` text,
	FOREIGN KEY (`day_id`) REFERENCES `days`(`id`) ON UPDATE no action ON DELETE cascade,
	CONSTRAINT "pain_intensity_range" CHECK("pain_episodes"."intensity" BETWEEN 1 AND 10)
);
--> statement-breakpoint
CREATE INDEX `idx_pain_day` ON `pain_episodes` (`day_id`);--> statement-breakpoint
CREATE TABLE `users` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`google_sub` text NOT NULL,
	`name` text NOT NULL,
	`email` text NOT NULL,
	`sleep_goal_hours` real DEFAULT 8 NOT NULL,
	`created_at` text DEFAULT (datetime('now')) NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `users_google_sub_unique` ON `users` (`google_sub`);--> statement-breakpoint
CREATE UNIQUE INDEX `users_email_unique` ON `users` (`email`);--> statement-breakpoint
CREATE TABLE `workouts` (
	`id` integer PRIMARY KEY AUTOINCREMENT NOT NULL,
	`day_id` integer NOT NULL,
	`activity_type_id` integer NOT NULL,
	`intensity` integer NOT NULL,
	`duration_min` integer,
	FOREIGN KEY (`day_id`) REFERENCES `days`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`activity_type_id`) REFERENCES `activity_types`(`id`) ON UPDATE no action ON DELETE no action,
	CONSTRAINT "workout_intensity_range" CHECK("workouts"."intensity" BETWEEN 1 AND 10)
);
--> statement-breakpoint
CREATE INDEX `idx_workouts_day` ON `workouts` (`day_id`);