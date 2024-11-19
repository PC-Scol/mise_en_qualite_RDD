
-- Cas des apprenants qui n'ont pas de diplome, donc l'année du dernier diplome obtenu ne peut pas etre alimentée
-- On la remplace temporairement par l'annee de la première inscription dans l'etablissement

update inscription
set annee_obtention_dernier_diplome=(select annee_entree_etablissement from apprenant where apprenant.id=inscription.id_apprenant)
where annee_obtention_dernier_diplome is null and code_type_dernier_diplome_obtenu='900';
