-- description : Aide au diagnostic des lignes retournées par ChoixCursus_Apogee_Incoherence_IPPRC_resultats_01_detection.sql
--					Pour chaque ligne de ChoixCursus_Apogee_Incoherence_IPPRC_resultats_01_detection.sql, retourne
--					 toutes les sources d'acquis trouvées avec pour chacune : 
--							- Type d'acquis : CAP (acquis classique), VAC (Validation d'acquis), LCC
--							- Periode source de l'acquis
--							- Element(s) source(s) de l'acquis (potentiellement différent de l'objet lui-même si LCC)
-- mode opératoire :
--		1. facultativement, décommenter la ligne "--AND ice.cod_anu>2020" et remplacer 2020 par l'année au-delà de laquelle
--			la détection doit être effectuée
--		2. lancer sur la base Apogée (requête en lecture)
-- auteur : Equipe RDD PC-SCOL

WITH parametres as (SELECT distinct ice.cod_anu, ice.cod_ind, ind.cod_etu, ice.cod_elp, ice.COD_LCC_ICE
                    FROM IND_CONTRAT_ELP ice
                        ,INDIVIDU ind
                    WHERE 
                      -- toutes les IP en PRC
                          ice.tem_prc_ice='O'
                      -- filtre facultatif pour filtrer sur les années à analyser
                      --AND ice.cod_anu>2020
                      AND ind.cod_ind = ice.cod_ind
                      -- toutes les IP en PRC
                      -- + ayant une ligne de résultat positif sur la même année (possible si semestrialisation des IP; cas géré par la RDD)
                      AND EXISTS (	SELECT 1
                                    FROM RESULTAT_ELP relp
                                    WHERE ice.cod_elp = relp.cod_elp
                                    AND ice.cod_anu = relp.cod_anu
                                    AND ice.cod_ind = relp.cod_ind
                                    AND relp.COD_ADM=1
                                    AND EXISTS (select 1 FROM TYP_RESULTAT TRE WHERE TRE.COD_TRE=relp.COD_TRE AND TRE.COD_NEG_TRE=1))
                      -- toutes les IP en PRC
                      -- + ayant une ligne de résultat positif sur la même année (cas gérés par la RDD, possible si semestrialisation des IP par exemple)
                      -- + ayant en même temps des résultats positifs dans le passé (cas non gérés par la RDD, potentiellement des renonciations, des erreurs de saisie potentielles pour l'année de la PRC ou une année passée, ...)
                      AND ( EXISTS (SELECT 1
                                    FROM RESULTAT_ELP relp
                                    WHERE relp.cod_ELP=ice.cod_elp
                                    AND relp.cod_ind=ice.cod_ind
                                    AND relp.cod_anu<ice.cod_anu
                                    AND relp.COD_ADM=1
                                    AND EXISTS (select 1 FROM TYP_RESULTAT TRE WHERE TRE.COD_TRE=relp.COD_TRE AND TRE.COD_NEG_TRE=1))
                            OR EXISTS (SELECT 1
                                    FROM ind_dispense_elp ide
                                    -- pas de filtre sur l'étape de la dispense car en saisie manuelle sans controle fort => peut être erronée
                                    WHERE ide.cod_anu<ice.cod_anu -- <= ou < ?
                                    AND ide.cod_ind=ice.cod_ind
                                    AND ide.cod_elp=ice.cod_elp)
                           OR EXISTS (SELECT 1
                                    FROM RESULTAT_ELP relp
                                    , ELP_CORRESPOND_ELP ece
                                    WHERE ece.COD_LCC=ice.COD_LCC_ICE
                                    AND ece.DAA_DEB_VAL_LCC<=ice.cod_anu
                                    AND nvl(ece.DAA_FIN_VAL_LCC,ice.cod_anu)>=ice.cod_anu
                                    AND relp.cod_ELP=ece.COD_ELP_S1_LCC
                                    AND relp.cod_ind = ice.cod_ind
                                    AND relp.cod_anu < ice.cod_anu
                                    AND relp.COD_ADM=1
                                    AND EXISTS (select 1 FROM TYP_RESULTAT TRE WHERE TRE.COD_TRE=relp.COD_TRE AND TRE.COD_NEG_TRE=1))
                        )
                    )
SELECT sous_table.cod_anu_ip_prc,sous_table.cod_etu,sous_table.cod_ind,sous_table.cod_elp_ip_prc,sous_table.code_periode_source,sous_table.type_acquis,sous_table.code_objet_source,sous_table.code_objet_source2
FROM (SELECT 'CAP' as type_acquis,p.cod_ind,p.cod_etu,p.cod_anu as cod_anu_ip_prc,p.cod_elp as cod_elp_ip_prc,p.cod_elp as code_objet_source,null as code_objet_source2,relp.COD_ANU as code_periode_source
    FROM RESULTAT_ELP relp
    , parametres p
    WHERE relp.cod_ELP=p.cod_elp
        AND relp.cod_ind = p.cod_ind
        AND relp.cod_anu <= p.cod_anu
        AND relp.COD_ADM=1
        AND EXISTS (select 1 FROM TYP_RESULTAT TRE WHERE TRE.COD_TRE=relp.COD_TRE AND TRE.COD_NEG_TRE=1)
    UNION
    SELECT 'VAC' as type_acquis,p.cod_ind,p.cod_etu,p.cod_anu as cod_anu_ip_prc,p.cod_elp as cod_elp_ip_prc,p.cod_elp as code_objet_source,null as code_objet_source2,ide.cod_anu as code_periode_source
    FROM ind_dispense_elp ide
    , parametres p
    -- pas de filtre sur l'étape de la dispense car en saisie manuelle sans controle fort => peut être erronée
    WHERE ide.cod_anu<p.cod_anu
        AND ide.cod_ind=p.cod_ind
        AND ide.cod_elp=p.cod_elp
    UNION
    SELECT 'LCC' as type_acquis,p.cod_ind,p.cod_etu,p.cod_anu as cod_anu_ip_prc,p.cod_elp as cod_elp_ip_prc,ece.COD_ELP_S1_LCC as code_objet_source,ece.COD_ELP_S2_LCC as code_objet_source2,relp.COD_ANU
    FROM RESULTAT_ELP relp
                , ELP_CORRESPOND_ELP ece
    , parametres p
    WHERE p.COD_LCC_ICE IS NOT NULL
        AND ece.COD_LCC=p.COD_LCC_ICE
        AND ece.DAA_DEB_VAL_LCC<=p.cod_anu
        AND nvl(ece.DAA_FIN_VAL_LCC,p.cod_anu)>=p.cod_anu
        AND relp.cod_ELP=ece.COD_ELP_S1_LCC
        AND relp.cod_ind = p.cod_ind
        AND relp.cod_anu <= p.cod_anu
        AND relp.COD_ADM=1
        AND EXISTS (select 1 FROM TYP_RESULTAT TRE WHERE TRE.COD_TRE=relp.COD_TRE AND TRE.COD_NEG_TRE=1)
    ) sous_table
    ORDER BY cod_anu_ip_prc,cod_etu,cod_elp_ip_prc,code_periode_source DESC,DECODE(type_acquis,'CAP',1,'VAC',2,'LCC',3)
;
