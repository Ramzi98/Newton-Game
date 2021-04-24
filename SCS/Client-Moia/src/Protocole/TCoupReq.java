package Protocole;

public class TCoupReq extends Newton{
    private TIdReq     idRequest;     /* Identificateur de la requete */
    private int        numPartie;     /* Numero de la partie (commencant a 1) */
    private TCoup      typeCoup;      /* Type coup */
    private Param      param;
    private TPropCoup  propCoup;      /* Propriete du coup proposee par le joueur */

    public TCoupReq(TIdReq idRequest, int numPartie, TCoup typeCoup, Param param, TPropCoup propCoup) {
        this.idRequest = idRequest;
        this.numPartie = numPartie;
        this.typeCoup = typeCoup;
        this.param = param;
        this.propCoup = propCoup;
    }

    public TIdReq getIdRequest() {
        return idRequest;
    }

    public void setIdRequest(TIdReq idRequest) {
        this.idRequest = idRequest;
    }

    public int getNumPartie() {
        return numPartie;
    }

    public void setNumPartie(int numPartie) {
        this.numPartie = numPartie;
    }

    public TCoup getTypeCoup() {
        return typeCoup;
    }

    public void setTypeCoup(TCoup typeCoup) {
        this.typeCoup = typeCoup;
    }

    public Param getParam() {
        return param;
    }

    public void setParam(Param param) {
        this.param = param;
    }

    public TPropCoup getPropCoup() {
        return propCoup;
    }

    public void setPropCoup(TPropCoup propCoup) {
        this.propCoup = propCoup;
    }
}
