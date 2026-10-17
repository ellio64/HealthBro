-- Custom SQL migration file, put your code below! --
CREATE VIEW weekly_stats AS
SELECT
  d.user_id,
  date(d.date, 'weekday 0', '-6 days')           AS week_start,   -- mandagen
  COUNT(*)                                       AS days_logged,
  AVG(d.water_ml)                                AS avg_water_ml,
  AVG(d.coffee_cups)                             AS avg_coffee,
  AVG(d.bowel_movements)                         AS avg_bowel,
  AVG(d.fruit_veg_servings)                      AS avg_fruit_veg,
  AVG(d.steps)                                   AS avg_steps,
  AVG(d.sleep_hours)                             AS avg_sleep_hours,
  AVG(d.sleep_score)                             AS avg_sleep_score,
  SUM(d.ate_fish)                                AS fish_days
FROM days d
GROUP BY d.user_id, week_start;