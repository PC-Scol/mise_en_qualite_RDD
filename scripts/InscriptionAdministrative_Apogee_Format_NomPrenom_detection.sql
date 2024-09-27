-- description : les noms et prénoms ne peuvent contenir "que" :
--   - des lettres ISO-8859-1 et Œœ
--   - les caractères ".", " ' ", "-" et espace
-- mode opératoire : lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT 'PROBLEME FORMAT LIB_NOM_PAT_IND' as "CONTROLE" FROM DUAL;
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND
FROM individu
WHERE NOT REGEXP_LIKE(LIB_NOM_PAT_IND, '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');

SELECT 'PROBLEME FORMAT LIB_NOM_USU_IND' as "CONTROLE" FROM DUAL;
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND
FROM individu
WHERE NOT REGEXP_LIKE(LIB_NOM_USU_IND, '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');

SELECT 'PROBLEME FORMAT PRENOM1' as "CONTROLE" FROM DUAL;
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND
FROM individu
WHERE NOT REGEXP_LIKE(LIB_PR1_IND, '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');

SELECT 'PROBLEME FORMAT PRENOM2' as "CONTROLE" FROM DUAL;
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND
FROM individu
WHERE NOT REGEXP_LIKE(LIB_PR2_IND, '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');

SELECT 'PROBLEME FORMAT PRENOM3' as "CONTROLE" FROM DUAL;
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND
FROM individu
WHERE NOT REGEXP_LIKE(LIB_PR3_IND, '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');
