-- description : Liste tous les apprenants qui ont un bac français (déterminé par rapport au bac.COD_SIS_BAC) obtenu dans un établissement "étranger" (code TPE=10)
--  ce qui est impossible fonctionnellement dans Pégase
-- Pour ces apprenants en erreur, dans Apogée, dans l'inscription de l'apprenant au niveau des données de bac, il faut enlever le code TPE 10 et
--  s'assurer que l'établissement renseigné est bien dans la nomenclature des établissements Apogée ( et pas les établissements étrangers !).
-- ancien nom: Apogee_bac_francais_etranger.sql
-- mode opératoire : lancer sur la base Apogée
-- auteur : Equipe RDD PC-SCOL

SELECT 
		ind.cod_ind "id",
		ind.LIB_NOM_PAT_IND "nom_famille",
		ind.LIB_NOM_USU_IND "nom_usuel",
		ind.LIB_PR1_IND "prenom",
		ind.LIB_PR2_IND "prenom2",
		ind.LIB_PR3_IND "prenom3",
		ind.COD_SEX_ETU "sexe",
		to_char(ind.DATE_NAI_IND,'YYYY-MM-DD') "date_naissance",
		DECODE(ind.COD_TYP_DEP_PAY_NAI,'P',ind.COD_DEP_PAY_NAI,'100') "code_pays_naissance",
		CASE WHEN nvl(ind.COD_TYP_DEP_PAY_NAI,'D')!='P' THEN
				coalesce(ind.COD_COM_NAI_ETU,commnaiss.COD_COM,'INCONNUE')
		END as "code_commune_naissance",
		DECODE(ind.COD_TYP_DEP_PAY_NAI,'D',ind.LIB_VIL_NAI_ETU) "libelle_commune_naissance",
		DECODE(ind.COD_TYP_DEP_PAY_NAI,'P',ind.LIB_VIL_NAI_ETU) "commune_naissance_etranger",
		ind.COD_PAY_NAT "code_nationalite",
		inb.DAA_OBT_BAC_IBA "annee_obtention_bac",
		inb.COD_BAC "code_type_ou_serie_bac",
		bac.COD_SIS_BAC "code_sise_bac",
		spb1.cod_sis_spe_bac "code_premiere_specialite_bac",
		spb2.cod_sis_spe_bac "code_deuxieme_specialite_bac",
		ind.COD_NNE_IND||ind.COD_CLE_NNE_IND "identifiant_national_etudiant"
FROM INDIVIDU ind
	,IND_BAC inb
	,INS_ADM_ANU iaa2
	,ETABLISSEMENT etb
	,BAC_OUX_EQU bac
	,SPECIALITE_BAC spb1
	,SPECIALITE_BAC spb2
	-- sous-requête pour ne conserver qu'une seule ligne dans la jointure vers COMMUNE
	,(SELECT LIB_COM, COD_DEP, COD_COM, row_number() OVER (PARTITION BY LIB_COM, COD_DEP ORDER BY COD_COM) AS rownumber
	  FROM COMMUNE) commnaiss
WHERE ind.COD_IND=inb.COD_IND
	AND inb.TEM_INS_ADM='O'
	AND etb.COD_ETB(+)=inb.COD_ETB
	AND inb.COD_BAC=bac.COD_BAC
	AND iaa2.cod_ind=ind.cod_ind
	AND inb.COD_SPE1_BAC_TER=spb1.cod_spe_bac(+)
	AND inb.COD_SPE2_BAC_TER=spb2.cod_spe_bac(+)
	-- jointure avec la commune de naissance
	-- consevation première commune dont nom commune de naissance et département correspondent
	-- reformatage à l identique des libellés commune des tables COMMUNE et INDIVIDU
	AND TRANSLATE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRANSLATE(TRANSLATE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(commnaiss.LIB_COM (+), 'ST', 'SAINT'), 'STE', 'SAINTE'), '/S', 'SUR'), '/', 'SUR'), '''', ''), '¨,.=()/\\[]_-{}:°!?;%*²@+^#§<>|£$¤"`.&', ' '), 'ÁÂÀÅÃÄÉÊÈËÍÎÌÏÓÔÒÖÇÑ', 'AAAAAAEEEEIIIIOOOOCN'), '( ){2,}', ' '), '([[:digit:]]{3,}).*', ''), '([012]{0,1}[[:digit:]]{1}).*', '\\1EME'), ' ([[:digit:]]{1}EME).*', ' 0\\1'), '01EME', '01ER'), '1 ', '1') = TRANSLATE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRANSLATE(TRANSLATE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(ind.LIB_VIL_NAI_ETU, 'ST', 'SAINT'), 'STE', 'SAINTE'), '/S', 'SUR'), '/', 'SUR'), '''', ''), '¨,.=()/\\[]_-{}:°!?;%*²@+^#§<>|£$¤"`.&', ' '), 'ÁÂÀÅÃÄÉÊÈËÍÎÌÏÓÔÒÖÇÑ', 'AAAAAAEEEEIIIIOOOOCN'), '( ){2,}', ' '), '([[:digit:]]{3,}).*', ''), '([012]{0,1}[[:digit:]]{1}).*', '\\1EME'), ' ([[:digit:]]{1}EME).*', ' 0\\1'), '01EME', '01ER'), '1 ', '1')
    AND commnaiss.COD_DEP (+)= ind.COD_DEP_PAY_NAI
    AND commnaiss.rownumber (+)= 1
	-- exclusion d une partie des echanges internationaux si demandée
	AND (nvl(iaa2.TEM_SNS_PRG,'SANS') NOT IN 'A' ) -- ex filtre : echanges entrants (A)
	-- recuperation de la derniere iaa disposant d 1 iae validée et payée
	AND iaa2.cod_anu=(SELECT max(iae.cod_anu)
									FROM INS_ADM_ETP iae
									WHERE iae.cod_ind=ind.cod_ind
										AND iae.eta_iae='E'
										AND iae.eta_pmt_iae='P'
		-->METTRE FILTRE VET ICI-->		--AND (iae.cod_dip,iae.cod_vrs_vdi,iae.cod_etp,iae.cod_vrs_vet) in (('HN5JEM',201,'H5JEM1',221),('HN5JEM',201,'H5JEM1',222),('HN5JEM',201,'H5JEM1',223),('HN5JEM',201,'H5JEM1',225),('HN5JEM',201,'H5JEM1',226))
        -->METTRE FILTRE ANNEE ICI-->	--AND iae.cod_anu in (2021)
									)
	AND bac.COD_SIS_BAC in('A','B','A1','A2','A3','A4','A5','A6','A7','C','D','DP','E','F1','F2','F3','F4','F5','F6','F7','F7P','F8','F9','F10','F10A','F10B','F','G1','G2','G3','G','H','HOT','S','L','ES','STI','STT','STG','STMG','STL','SMS','ST2S','STAE','STPA','STAV','TD2A','TI2D','F11','F11P','F12','STHR','0021','0022','0023','NBGE')
    AND etb.COD_TPE='10'
    --AND ind.cod_etu in ('22106127')