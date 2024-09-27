-- description : Liste de toutes les IP n'étant pas en PRC sous une IP mère en PRC
-- ancien nom : Apogee_IP_sous_IP_PRC.sql
-- mode opératoire : lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT connect_by_root(ice.cod_anu) AS COD_ANU
	, connect_by_root(ice.cod_ind) AS COD_IND
	, connect_by_root(ice.cod_etp) AS COD_ETP
	, connect_by_root(ice.cod_vrs_vet) AS COD_VRS_VET
	, ice.cod_elp AS cod_elp
	, ice.TEM_PRC_ICE
	, connect_by_root(ice.cod_etp)||'-'||connect_by_root(ice.cod_vrs_vet)||SYS_CONNECT_BY_PATH(ice.cod_elp, '>') AS CHEMIN_DEPUIS_VET_SANS_LISTE
	, connect_by_root(ice.cod_etp)||'-'||connect_by_root(ice.cod_vrs_vet)||replace(SYS_CONNECT_BY_PATH('(liste)'||ice.cod_lse||'>'||ice.cod_elp, '>>'),'>>','>') AS CHEMIN_DEPUIS_VET_AVEC_LISTE
FROM IND_CONTRAT_ELP ice
	,LISTE_ELP lse
WHERE lse.cod_lse=ice.cod_lse
CONNECT BY	PRIOR ice.cod_elp = ice.cod_elp_sup
		AND PRIOR ice.cod_anu=ice.cod_anu
		AND PRIOR ice.cod_etp=ice.cod_etp
		AND PRIOR ice.cod_vrs_vet=ice.cod_vrs_vet
		AND PRIOR ice.cod_ind=ice.cod_ind
		AND ice.tem_prc_ice='N'
START WITH (ice.tem_prc_ice='O'
			AND EXISTS (select 1
						from ind_contrat_elp fils
						where ice.cod_elp = fils.cod_elp_sup
							AND ice.cod_anu=fils.cod_anu
							AND ice.cod_etp=fils.cod_etp
							AND ice.cod_vrs_vet=fils.cod_vrs_vet
							AND ice.cod_ind=fils.cod_ind
							AND fils.tem_prc_ice='N')
			)
ORDER BY COD_ANU, COD_IND, COD_ETP, COD_VRS_VET, CHEMIN_DEPUIS_VET_SANS_LISTE;
