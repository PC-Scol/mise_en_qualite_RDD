-- description : Liste de toutes les IP en PRC ayant des lignes de résultat pour le même élément, le même apprenant et la même période
-- ancien nom : Apogee_IP_PRC_avec_RESULTAT_ELP_v2.sql
-- mode opératoire :
--		1. facultativement, décommenter la ligne "--AND ice.cod_anu>2021" et remplacer 2021 par l'année souhaitée
--			pour filtrer sur les années à analyser
--		2. lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT ice.cod_anu
		, ind.cod_etu
		, ice.cod_elp
		, ice.cod_etp
		, ice.cod_vrs_vet
FROM IND_CONTRAT_ELP ice
	,INDIVIDU ind
WHERE ice.tem_prc_ice='O'
  AND ind.cod_ind = ice.cod_ind
  AND EXISTS (	SELECT 1
				FROM RESULTAT_ELP relp
				WHERE ice.cod_elp = relp.cod_elp
				AND ice.cod_anu = relp.cod_anu
				AND ice.cod_ind = relp.cod_ind)
  --AND ice.cod_anu>2021
order by cod_anu, cod_etu, cod_elp;
