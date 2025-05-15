
-- Creation d'une quotité Z dans le fichier de transco quotiteActivite.xlsx : Z	QUA007	NON RENSEIGNEE RDD APOGEE
-- Les valeurs du code sources sont a ajuster en fonction de l'etablissement
-- auteur : UGA

-- Cas 1  : Eleves
update apprenant set code_quotite_travaillee='F'
where code_quotite_travaillee in ('A','B','C') and apprenant.code_categorie_socioprofessionnelle like '84' ;	


-- "autre situation professionnelle" 99 => PCS 046
update apprenant set code_quotite_travaillee='F'
where  apprenant.code_categorie_socioprofessionnelle like '99' and code_quotite_travaillee not in ('F','E','INCONNUE')	;	

-- Cas 3 : 10, 11, 12, 13 => PCS001 Agriculteur
update apprenant set code_quotite_travaillee='A'
where  apprenant.code_categorie_socioprofessionnelle in ('10','11','12','13')  and code_quotite_travaillee in ('F','E','INCONNUE')   ;   

--Cas PCS 006 , PCS 007, PCS 008 : chef d'entreprise
update apprenant set code_quotite_travaillee='A'
where  apprenant.code_categorie_socioprofessionnelle in ('21', '22', '23','31')  and  code_quotite_travaillee in ('F','E','INCONNUE')   ;   

update apprenant set code_quotite_travaillee='A'
where  apprenant.code_categorie_socioprofessionnelle in ('33', '34', '35','36')   and  code_quotite_travaillee in ('F','E','INCONNUE') ;

-- Les autres cas d'anomalie
update apprenant set code_quotite_travaillee='Z'
where  apprenant.code_categorie_socioprofessionnelle in ('37','38','42','43','44','45','46','47','48','50','51','52','53','54','55','56','61','62','63','64','65','66','67','68','69' )     
and  code_quotite_travaillee in ('F','E','INCONNUE')   ;    

update apprenant set code_quotite_travaillee='F'
where apprenant.code_categorie_socioprofessionnelle='66' and code_quotite_travaillee='A';
