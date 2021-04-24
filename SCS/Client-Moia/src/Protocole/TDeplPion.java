package Protocole;

public class TDeplPion extends Newton{
    private TCoul coulPion;         /* Couleur du pion */
    private TCol  colPion;          /* Colonne du pion a deplacer */
    private TLg   lgPionD;          /* Nouvelle ligne du pion deplace */

    public TDeplPion(TCoul coulPion, TCol colPion, TLg lgPionD) {
        this.coulPion = coulPion;
        this.colPion = colPion;
        this.lgPionD = lgPionD;
    }

    public TCoul getCoulPion() {
        return coulPion;
    }

    public void setCoulPion(TCoul coulPion) {
        this.coulPion = coulPion;
    }

    public TCol getColPion() {
        return colPion;
    }

    public void setColPion(TCol colPion) {
        this.colPion = colPion;
    }

    public TLg getLgPionD() {
        return lgPionD;
    }

    public void setLgPionD(TLg lgPionD) {
        this.lgPionD = lgPionD;
    }
}
