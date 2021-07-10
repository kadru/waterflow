CREATE TRIGGER add_last_waterflow_id_to_gage
  AFTER INSERT
  ON waterflows
  FOR EACH ROW
  EXECUTE PROCEDURE add_last_waterflow_id_to_gage();
