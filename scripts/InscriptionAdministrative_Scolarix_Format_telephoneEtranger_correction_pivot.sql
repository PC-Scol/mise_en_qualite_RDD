-- description : script spécifique Scolarix de correction de téléphones dans la base pivot à partir d'éléments recueillis dans la base Scolarix
-- ancien nom: Scolarix_update_pivot_telephone.sql
-- mode opératoire :
--		1. lancer sur la base scolarix et mettre de côté le résultat obtenu
--		2. lancer le résultat obtenu sur la base pivot pour y mettre en qualité les téléphones
-- auteur : ???
SELECT 'DO' FROM dual
UNION ALL 
SELECT '$$' FROM dual
UNION ALL
SELECT 'BEGIN' FROM dual
UNION ALL 
SELECT 
	'update apprenant_contacts set telephone = '''||'+'||pt.INDICATIF||REGEXP_REPLACE(pt.NO_TELEPHONE,'^0','')||''' where id_apprenant = '''||ind.NO_INDIVIDU||''' and telephone like '''||pt.NO_TELEPHONE||'''; ' requete
FROM grhum.individu_ulr ind, 
	grhum.etudiant et, 
	garnuche.historique hi, 
grhum.personne_telephone pt
WHERE ind.NO_INDIVIDU = et.NO_INDIVIDU 
AND et.ETUD_NUMERO = hi.ETUD_NUMERO 
AND ind.PERS_ID = pt.PERS_ID
AND TRIM(pt.NO_TELEPHONE) IS NOT NULL
AND hi.HIST_ANNEE_SCOL = 2021
UNION ALL 
SELECT 'END;' FROM dual 
UNION ALL 
SELECT '$$' FROM dual;