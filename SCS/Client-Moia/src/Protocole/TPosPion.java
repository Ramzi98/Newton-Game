package Protocole;

public class TPosPion extends Newton{
    private TCoul coulPion;         /* Couleur du pion */
    private TCase posPion;          /* Position de la case du pion place */

    public TPosPion(TCoul coulPion, TCase posPion) {
        this.coulPion = coulPion;
        this.posPion = posPion;
    }

    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }

    public TCase getPosPion() {
        return posPion;
    }

    public void setPosPion(TCase posPion) {
        this.posPion = posPion;
    }
}
