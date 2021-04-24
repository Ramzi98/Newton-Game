package Protocole;

public abstract class Newton {

    public static final int T_NOM = 30;

    /* Identificateurs des requetes */
    public enum TIdReq { PARTIE, COUP }

    /* Types d'erreur */
    public enum TCodeRep { ERR_OK,      /* Validation de la requete */
            ERR_PARTIE,  /* Erreur sur la demande de partie */
            ERR_COUP,    /* Erreur sur le coup joue */
            ERR_TYP      /* Erreur sur le type de requete */
    }

    /*
     * Structures demande de partie
     */
    public enum TCoul{ BLEU, ROUGE }


    /*
     * Definition d'une position de case
     */
    public enum TLg { A, B, C, D, E, F, G, H }
    public enum TCol { UN, DEUX, TROIS, QUATRE, CINQ }

    /* Coups possibles */
    public enum TCoup { POSE, DEPL }

    /* Propriete des coups */
    public enum TPropCoup { CONT, GAGNE, NUL, PERDU }

    /* Validite du coup */
    public enum TValCoup{ VALID, TIMEOUT, TRICHE }

    int little2big(int i) {
        return (i&0xff)<<24 | (i&0xff00)<<8 | (i&0xff0000)>>8 | (i>>24)&0xff;
    }
}
