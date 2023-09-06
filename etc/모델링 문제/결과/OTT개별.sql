CREATE SEQUENCE OTT_Seq;
INSERT INTO mTBLOTT(OTT_Seq,name)values((SELECT nvl(max(OTT_Seq), 0) + 1 FROm mTBLOTT),'웨이브');
INSERT INTO mTBLOTT(OTT_Seq,name)values((SELECT nvl(max(OTT_Seq), 0) + 1 FROm mTBLOTT),'넷플릭스');
INSERT INTO mTBLOTT(OTT_Seq,name)values((SELECT nvl(max(OTT_Seq), 0) + 1 FROm mTBLOTT),'왓챠');
INSERT INTO mTBLOTT(OTT_Seq,name)values((SELECT nvl(max(OTT_Seq), 0) + 1 FROm mTBLOTT),'티빙');
DROP SEQUENCE OTT_Seq;
