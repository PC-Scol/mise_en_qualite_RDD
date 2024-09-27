# Reprise de données - Mise en qualité - Problèmes rencontrés / solutions apportées

## Public ciblé
Les documents et scripts contenus dans ce dépôt sont destinés :

* aux établissements qui souhaitent commencer la mise en qualité de leurs données en amont de leur travail de reprise de données vers Pégase, quelle que soit leur application de scolarité source (Apogée, Scolarix, SVE, autre application),
* aux établissements en cours de travail sur leur reprise de données vers Pégase.

## Objectif
L'objectif de ce dépôt est de permettre aux établissements de :

* **partager** les problèmes rencontrés et solutions utilisées,
* **commencer la mise en qualité** de leurs données avant même d'avoir commencé à utiliser l'outillage de reprise de données (par exemple s'ils souhaitent effectuer une reprise de leurs données vers Pégase mais n'ont pas encore intégré de vague de déploiement).

## Contenu
Ce dépôt rassemble :

* dans le fichier `Mise_en_qualite_Problemes_et_solutions.csv` à la racine, la liste des problèmes qui ont été rencontrés jusqu'à ce jour lors de la mise en qualité des données avant bascule vers Pégase ainsi que les solutions (manuelles ou scriptées) qui ont été apportées,
* dans le répertoire `scripts/`, les éventuels scripts de détection et de correction qui ont pu être développés pour l'occasion (si la détection des problèmes et/ou les corrections étaient automatisables).

## Description générale, fonctionnement
Ces fichiers sont des ressources communautaires qui ont vocation à être enrichies par les établissements. Le principe de contribution proposé est le suivant :
1. Lorsqu'un nouveau problème de qualité de données est rencontré, l'établissement qui le rencontre le consigne dans la liste `Mise_en_qualite_Problemes_et_solutions.csv`.
2. Si l'établissement a trouvé une solution (avec ou sans l'aide de l'équipe PC-Scol), il rajoute sa description en face du problème dans le fichier.
3. Si des scripts ont été développés pour détecter ou corriger automatiquement le problème, ils sont déposés dans le répertoire `scripts/` selon les normes détaillées plus bas puis référencés dans le fichier `Mise_en_qualite_Problemes_et_solutions.csv`. **/!\\** PC-Scol n'est pas responsable des scripts partagés et ne garantit pas leur contenu. Il est de la responsabilité de chaque établissement de s'assurer de l'effet des scripts exécutés.
4. Les établissements consultant la liste des problèmes sont alors en capacité d'anticiper ou de corriger le problème mentionné dans leur application de scolarité source. S'ils ont une autre solution à apporter, ils peuvent collaborer en complétant le fichier et/ou les scripts.

## Description du fichier Mise_en_qualite_Problemes_et_solutions.csv
Le fichier est au format CSV, à raison d'un problème par ligne. Chaque ligne est composée des colonnes suivantes :

* **Famille de données** : Famille métier à laquelle les données à mettre en qualité appartiennent. Valeur parmi : "Nomenclatures", "OffreFormation", "InscriptionAdministrative", "ChoixCursus", "ContrôleCursus".
* **Application source** : Liste des applications sources concernées par le problème de qualité rencontré. Valeur parmi : "Apogée", "Scolarix", "SVE", "Autres". Si l'application source n'est ni Apogée, ni Scolarix, ni SVE mais qu'elle est potentiellement utilisée par plusieurs établissements alors il est possible de mettre son nom. En revanche s'il s'agit d'une solution propriétaire destinée à l'usage exclusif d'un établissement, mettre "Autres" suffit.
* **Catégorie de problème** : Catégorie du problème de qualité de donnée rencontré. Valeur parmi :
  - "DonneeAbsente" : la donnée est absente ou facultative dans la source et obligatoire dans Pégase,
  - "DonneeNonReprise" : les flux de reprise de données ne reprennent pas cette donnée,
  - "EvolutionDesReferentiels" : les nomenclatures utilisées dans les référentiels source et Pégase divergent,
  - "Format" : le format des données de la source n'est pas compatible avec le format attendu par Pégase,
  - "Incoherence" : les valeurs de plusieurs données de la source sont incohérentes entre elles selon les règles suivies dans Pégase,
  - "OccurrenceManquante" : une occurrence de nomenclature présente dans la source n'existe pas dans Pégase et doit donc y être ajoutée,
  - "RDDdansLeTemps" : problèmes liés aux reprises de données qui durent dans le temps : modifications des données sources déjà mises en qualité, passages en production par périmètres progressifs,...
  - "Validite" : la donnée récupérée depuis la source est invalide dans Pégase,
  - ou toute autre nouvelle catégorie de problème. En cas d'ajout, merci d'ajouter la nouvelle catégorie à cette liste et d'expliciter son contenu.
* **Problème de qualité de donnée rencontré** : Description complète du problème de qualité de donnée rencontré.
* **Solution/contournement** : Description complète de la solution apportée au problème. Si aucune solution n'a été trouvée l'indiquer avec le cas échéant la raison.
* **Scripts** :
  - soit nom du(des) script(s) permettant de répondre au problème énoncé,
  - soit "TODO" pour indiquer que le script n'a pas encore été fait ou déposé dans l'espace de partage des scripts et qu'il peut être développé par tout établissement qui le souhaite.
  - soit "N/A" pour indiquer que l'utilisation d'un ou plusieurs scripts est Non Applicable
* **Date de dernière modification** : date d'ajout ou de dernière modification de la ligne.

## Description des scripts du répertoire scripts/
Tous les scripts sont déposés à la racine du répertoire `scripts`

Il sont nommés 
```
<Famille de données>_<Application source>_<Catégorie de problème>_<problème>_<type script>_<base concernée>.<extension>
```
où:

* `<Famille de données>`, `<Application source>` et `<Catégorie de problème>` ont les mêmes valeurs que celles définies dans les colonnes du fichier `Mise_en_qualite_Problemes_et_solutions.csv` (cf. ci-dessus).
* `<problème>` : Description très synthétique du problème. Peut indiquer par exemple la données sur laquelle la <catégorieProblème> porte.
* `<type script>` :
    - "detection" : script de détection du problème référencé. Il n'y a pas forcément de script de détection pour tous les problèmes référencés. Un script de détection est valable uniquement pour une application source.
    - "correction" : script de correction du problème référencé. Il n'y a pas forcément de script de correction pour tous les problèmes référencés. Un script de correction est valable uniquement pour une application source si la correction est réalisée directement à la source. Il peut en revanche être valable pour plusieurs application sources s'il est conçu pour être exécuté en base pivot (dans ce cas, il est nécessaire d'installer la base pivot et donc d'avancer dans le processus de RDD).
* `<base concernée>` : (optionnel) ne doit être utilisé que si la base concernée par le script n'est pas celle de `<Application source>`.
* `<extension>` : le nom de l'extension correspondant au type de base sur laquelle passer la(les) requête(s).

Exemples :
* script de détection de notes ou résultats (données de contrôle de cursus) présents dans Apogée sur des objets de formation pourtant capitalisés (en PRC) : `ControleCursus_Apogee_Incoherence_NoteResultatSansIP_detection.sql`
* script de correction de formats de téléphone Scolarix incorrects (données d'inscription administrative) à passer sur la base pivot : `InscriptionAdministrative_Scolarix_Format_telephoneEtranger_correction_pivot.sql`

Les scripts développés doivent être commentés et contenir en entête le cartouche suivant :
```
description : <description du script: contexte, problème résolu, éléments clés du script si besoin ...>
mode opératoire : <mode opératoire d'utilisation du script in indiquant comment le lancer et la liste des paramètres à compléter s'il y en a>
createur : <établissement auteur du script>
contact : <mél de la personne à contacter en cas de besoin de renseignements supplémentaires> (optionnel)
```


## En cas de questions ou de problème avec l'application des solutions référencées...
Il est rappelé que les solutions proposées **NE doivent JAMAIS** être appliquées directement en production. Elles doivent d'abord être testées sur les environnements idoines.

En cas de questions ou de problèmes avec l'application des solutions proposées, contacter, par ordre de préférence :

1. les autres établissements : déposer un message sur le forum PC-Scol,
2. l'équipe rdd PC-Scol : déposer un ticket sur JSM avec votre compte établissement.
