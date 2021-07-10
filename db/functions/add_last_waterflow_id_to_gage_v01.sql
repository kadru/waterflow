CREATE OR REPLACE FUNCTION add_last_waterflow_id_to_gage() 
   RETURNS TRIGGER 
   LANGUAGE PLPGSQL
AS $$
DECLARE
  most_recent_waterflow record;
BEGIN
  SELECT id, captured_at
  INTO most_recent_waterflow
  FROM waterflows
  WHERE gage_id = NEW.gage_id
  ORDER BY captured_at DESC
  LIMIT 1;

  IF FOUND THEN
    RAISE NOTICE 'found captured_at';
    IF NEW.captured_at > most_recent_waterflow.captured_at THEN
      RAISE NOTICE 'new is greater than last_captured_at';
      UPDATE gages
      SET last_waterflow_id = NEW.id
      WHERE id = NEW.gage_id;
      RAISE NOTICE 'UPATED IN GREATER THAN';
    ELSE
      RAISE NOTICE 'new is not greater than las_captured_at';
      UPDATE gages
      SET last_waterflow_id = most_recent_waterflow.id
      WHERE id = NEW.gage_id;
      RAISE NOTICE 'UPATED IN NO GREATER THAN';
    END IF;
  ELSE
    UPDATE gages
    SET last_waterflow_id = NEW.id
    WHERE id = NEW.gage_id;
    RAISE NOTICE 'UPDATED IN NOT FOUND';
  END IF;

  RETURN NEW;
END;
$$
