package Protocole;

public class TPartieRep extends Newton {
    private TCodeRep err;               /* Code de retour */
    private char[] nomAdvers = new char[T_NOM];      /* Nom du joueur adverse */
    private TCoul coulPion;             /* Couleur pour le pion */

    public TCodeRep getErr() {
        return err;
    }

    public void setErr(TCodeRep err) {
        this.err = err;
    }

    public char[] getNomAdvers() {
        return nomAdvers;
    }

    public void setNomAdvers(char[] nomAdvers) {
        this.nomAdvers = nomAdvers;
    }

    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }
}
