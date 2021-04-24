package Protocole;

public class TCase extends Newton{
    private TLg l;           /* Ligne de la position d'un pion */
    private TCol c;          /* Colonne de la position d'un pion */

    public TCase(TLg l, TCol c) {
        this.l = l;
        this.c = c;
    }

    public TLg getL() {
        return l;
    }

    public void setL(TLg l) {
        this.l = l;
    }

    public TCol getC() {
        return c;
    }

    public void setC(TCol c) {
        this.c = c;
    }
}
