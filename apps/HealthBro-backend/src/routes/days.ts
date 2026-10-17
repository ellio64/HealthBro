import { Hono } from 'hono'
import { getDb } from '../db/client'
import { days } from '../db/schema'

type Env = { Bindings: { DB: D1Database }; Variables: { userId: number } }
export const daysRoute = new Hono<Env>()

daysRoute.put('/:date', async (c) => {
  const db = getDb(c.env.DB)
  const userId = c.get('userId') // settes av auth-middleware
  const body = await c.req.json() // valider med Zod i praksis

  await db.insert(days)
    .values({ userId, date: c.req.param('date'), ...body })
    .onConflictDoUpdate({ target: [days.userId, days.date], set: body })

  return c.json({ ok: true })
})