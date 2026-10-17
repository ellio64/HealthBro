import { sql } from 'drizzle-orm'
import { sqliteTable, integer, text, real, unique, index, check } from 'drizzle-orm/sqlite-core'

export const users = sqliteTable('users', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  googleSub: text('google_sub').notNull().unique(),
  name: text('name').notNull(),
  email: text('email').notNull().unique(),
  sleepGoalHours: real('sleep_goal_hours').notNull().default(8),
  createdAt: text('created_at').notNull().default(sql`(datetime('now'))`),
})

export const days = sqliteTable('days', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  date: text('date').notNull(), // 'YYYY-MM-DD'
  fruitVegServings: integer('fruit_veg_servings'),
  bowelMovements: integer('bowel_movements'),
  waterMl: integer('water_ml'),
  coffeeCups: integer('coffee_cups'),
  steps: integer('steps'),
  ateFish: integer('ate_fish', { mode: 'boolean' }),
  restingPulse: integer('resting_pulse'),
  bedtime: text('bedtime'),
  wakeTime: text('wake_time'),
  sleepHours: real('sleep_hours'),
  sleepScore: integer('sleep_score'),
}, (t) => [
  unique().on(t.userId, t.date),
  check('sleep_score_range', sql`${t.sleepScore} BETWEEN 0 AND 100`),
])

export const painEpisodes = sqliteTable('pain_episodes', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  dayId: integer('day_id').notNull().references(() => days.id, { onDelete: 'cascade' }),
  intensity: integer('intensity').notNull(),
  bodyArea: text('body_area'),
  note: text('note'),
}, (t) => [
  index('idx_pain_day').on(t.dayId),
  check('pain_intensity_range', sql`${t.intensity} BETWEEN 1 AND 10`),
])

export const activityTypes = sqliteTable('activity_types', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  userId: integer('user_id').notNull().references(() => users.id, { onDelete: 'cascade' }),
  name: text('name').notNull(),
  category: text('category', { enum: ['aerobic', 'anaerobic'] }).notNull(),
}, (t) => [unique().on(t.userId, t.name)])

export const workouts = sqliteTable('workouts', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  dayId: integer('day_id').notNull().references(() => days.id, { onDelete: 'cascade' }),
  activityTypeId: integer('activity_type_id').notNull().references(() => activityTypes.id),
  intensity: integer('intensity').notNull(),
  durationMin: integer('duration_min'),
}, (t) => [
  index('idx_workouts_day').on(t.dayId),
  check('workout_intensity_range', sql`${t.intensity} BETWEEN 1 AND 10`),
])