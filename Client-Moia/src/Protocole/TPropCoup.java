package Protocole;

/* Propriete des coups */
public enum TPropCoup {
    CONT, GAGNE, NUL, PERDU;

    public static TPropCoup setTPropCoup(int a){
        TPropCoup tPropCoup = null;
        switch(a){
            case 0:
                tPropCoup = TPropCoup.CONT;
                break;
            case 1:
                tPropCoup = TPropCoup.GAGNE;
                break;
            case 2:
                tPropCoup = TPropCoup.NUL;
                break;
            case 3:
                tPropCoup = TPropCoup.PERDU;
                break;
        }
        return tPropCoup;
    }
}
