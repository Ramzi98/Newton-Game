/************************************************************
 *
 * Programme : protocolNewton.h
 *
 * Synopsis : entete du protocole d'acces au serveur arbitre
 *            pour le jeu Newton
 *
 * Ecrit par : VF, FB
 * Date :  09 / 02 / 21
 * 
 ************************************************************/

#ifndef _PROTO_NEWTON_H
#define _PROTO_NEWTON_H

#include <stdbool.h>

/* Taille des chaines de caracteres pour les noms */
#define T_NOM 30

/* Identificateurs des requetes */
typedef enum { PARTIE, COUP } TIdReq;

/* Types d'erreur */
typedef enum { ERR_OK,      /* Validation de la requete */
	       ERR_PARTIE,  /* Erreur sur la demande de partie */
	       ERR_COUP,    /* Erreur sur le coup joue */
	       ERR_TYP      /* Erreur sur le type de requete */
} TCodeRep;

/* 
 * Structures demande de partie
 */ 
typedef enum { BLEU, ROUGE } TCoul;

typedef struct {
  TIdReq idReq;               /* Identificateur de la requete */
  char nomJoueur[T_NOM];      /* Nom du joueur */
} TPartieReq;

typedef struct {
  TCodeRep err;               /* Code de retour */
  char nomAdvers[T_NOM];      /* Nom du joueur adverse */
  TCoul coulPion;             /* Couleur pour le pion */
} TPartieRep;


/* 
 * Definition d'une position de case
 */
typedef enum { A, B, C, D, E, F, G, H } TLg;
typedef enum { UN, DEUX, TROIS, QUATRE, CINQ } TCol;

typedef struct {
  TLg l;           /* Ligne de la position d'un pion */
  TCol c;          /* Colonne de la position d'un pion */
} TCase;

/* 
 * Definition de structures pour les actions sur un pion
 */

/* Coups possibles */
typedef enum { POSE, DEPL } TCoup;

/* Parametres des coups */
typedef struct {
  TCoul coulPion;         /* Couleur du pion */
  TCase posPion;          /* Position de la case du pion place */
} TPosPion;

typedef struct {
  TCoul coulPion;         /* Couleur du pion */
  TCol  colPion;          /* Colonne du pion a deplacer */
  TLg   lgPionD;          /* Nouvelle ligne du pion deplace */ 
} TDeplPion;

/* Propriete des coups */
typedef enum { CONT, GAGNE, NUL, PERDU } TPropCoup;

/* Requete de coup */
typedef struct {
  TIdReq     idRequest;     /* Identificateur de la requete */
  int        numPartie;     /* Numero de la partie (commencant a 1) */
  TCoup      typeCoup;      /* Type coup */
  union {
    TPosPion  posePion;
    TDeplPion deplPion;
  } param;
  TPropCoup  propCoup;      /* Propriete du coup proposee par le joueur */
} TCoupReq;

/* Validite du coup */
typedef enum { VALID, TIMEOUT, TRICHE } TValCoup;

/* Reponse a un coup */
typedef struct {
  TCodeRep  err;            /* Code de retour */
  TValCoup  validCoup;      /* Validite du coup */
  TPropCoup propCoup;       /* Propriete du coup suite a la validation de l'arbitre */
} TCoupRep;

#endif