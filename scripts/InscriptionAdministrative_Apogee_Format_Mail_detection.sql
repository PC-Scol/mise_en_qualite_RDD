-- description : Liste des mail avec format incorrect
-- mode opératoire : lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT 'PROBLEME FORMAT ADRESSE.ADR_MAIL' as "CONTROLE" FROM DUAL;
SELECT ind.COD_IND,ind.COD_ETU,ind.LIB_NOM_PAT_IND,ind.LIB_NOM_USU_IND,ind.LIB_PR1_IND,ind.LIB_PR2_IND,ind.LIB_PR3_IND,ind.LIB_VIL_NAI_ETU, adr.ADR_MAIL
FROM INDIVIDU ind
INNER JOIN ADRESSE adr ON adr.COD_IND_INA=ind.cod_ind
WHERE adr.ADR_MAIL IS NOT NULL
AND NOT REGEXP_LIKE(adr.ADR_MAIL, '[-!#$%&''*+/0-9=?A-Z^_`a-z{|}~]+(.[-!#$%&''*+/0-9=?A-Z^_`a-z{|}~]+)*@[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(.[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)+');
