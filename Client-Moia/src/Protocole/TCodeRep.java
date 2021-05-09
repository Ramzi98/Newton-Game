package Protocole;

/* Types d'erreur */
public enum TCodeRep {
    ERR_OK,      /* Validation de la requete */
    ERR_PARTIE,  /* Erreur sur la demande de partie */
    ERR_COUP,    /* Erreur sur le coup joue */
    ERR_TYP      /* Erreur sur le type de requete */
}