package Protocole;

public class TPartieReq extends Newton {
    private TIdReq idReq;               /* Identificateur de la requete */
    private char[] nomJoueur = new char[T_NOM];      /* Nom du joueur */

    public TPartieReq(TIdReq idReq, char[] nomJoueur) {
        this.idReq = idReq;
        this.nomJoueur = nomJoueur;
    }

    public TIdReq getIdReq() {
        return idReq;
    }

    public void setIdReq(TIdReq idReq) {
        this.idReq = idReq;
    }

    public char[] getNomJoueur() {
        return nomJoueur;
    }

    public void setNomJoueur(char[] nomJoueur) {
        this.nomJoueur = nomJoueur;
    }
}
