-- description : Script Apogée de listing de toutes les IPs en PRC ayant à la fois :
--					- des résultats potififs classiques pour le même élément, le même apprenant et la même année
--					- des résultats positifs (classiques ou via LCC) ou VAC pour le même élément, le même apprenant et des années précédentes 
--				Il y a un RISQUE QUE CES CAS NE SOIENT PAS GÉRÉS PAR LA RDD.
--				Les IPs retournées devront être analysées avec les résultats associés pour savoir s'ils sont fonctionnellement
--				 normaux (ex: renonciation) ou anormaux(ex: erreur de saisie) et quel correction y apporter pour la RDD.
--					ex: si renonciation (fonctionnellement normal mais non-géré par les flux de RDD) :
--							1. via script, supprimer le choix d'acquis pour l'IP en PRC déversée en base pivot
--							2. via flux RDD, injecter le cursus
--							3. manuellement dans Pégase, renoncer à l'acquis + saisir aménagement VAL-EVAL
-- mode opératoire :
--		1. facultativement, décommenter la ligne "--AND ice.cod_anu>2020" et remplacer 2020 par l'année au-delà de laquelle
--			la détection doit être effectuée
--		2. lancer sur la base Apogée (requête en lecture)
-- auteur : Equipe RDD PC-SCOL

SELECT ice.cod_anu as cod_anu_ip_prc
		, ind.cod_etu
		, ind.cod_ind
		, ice.cod_elp as cod_elp_ip_prc
		, ice.cod_etp
		, ice.cod_vrs_vet
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
  -- + ayant des résultats positifs dans le passé (cas non gérés par la RDD, potentiellement des renonciations, des erreurs de saisie potentielles pour l'année de la PRC ou une année passée, ...)
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
                WHERE ide.cod_anu<ice.cod_anu
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
order by cod_anu, cod_etu, cod_elp;