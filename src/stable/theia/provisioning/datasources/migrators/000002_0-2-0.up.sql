--Alter table to add new columns
ALTER TABLE flows
ADD COLUMN clusterUUID String;
ALTER TABLE flows_local
ADD COLUMN clusterUUID String;
