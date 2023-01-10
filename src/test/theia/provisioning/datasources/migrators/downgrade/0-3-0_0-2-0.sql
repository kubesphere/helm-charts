--Alter table to drop new columns
ALTER TABLE flows
DROP clusterUUID String;
ALTER TABLE flows_local
DROP clusterUUID String;
