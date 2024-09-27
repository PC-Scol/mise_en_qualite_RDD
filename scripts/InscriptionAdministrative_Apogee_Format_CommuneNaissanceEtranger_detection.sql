-- description :les libellés communes étrangères de apprenant.commune_naissance_etranger ne peuvent contenir "que" :
--   - des lettres ISO-8859-1 et Œœ
--   - les caractères ".", " ' ", "-" et espace
-- mode opératoire : lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT 'PROBLEME FORMAT LIB_VIL_NAI_ETU' as "CONTROLE" FROM DUAL;
-- si individu.COD_TYP_DEP_PAY_NAI='P' alors naissance à l'étranger => individu.LIB_VIL_NAI_ETU contient la commune de naissance à l'étranger
SELECT COD_IND,COD_ETU,LIB_NOM_PAT_IND,LIB_NOM_USU_IND,LIB_PR1_IND,LIB_PR2_IND,LIB_PR3_IND,ind.LIB_VIL_NAI_ETU
FROM INDIVIDU ind
WHERE coalesce(ind.COD_TYP_DEP_PAY_NAI,'X')='P'
AND NOT REGEXP_LIKE(coalesce(LIB_VIL_NAI_ETU,'X'), '^[a-zA-ZÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõöøùúûüýþÿŒœ ''-.]*$');
