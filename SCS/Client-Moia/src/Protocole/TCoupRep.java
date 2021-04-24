package Protocole;

public class TCoupRep extends Newton{
    TCodeRep  err;            /* Code de retour */
    TValCoup  validCoup;      /* Validite du coup */
    TPropCoup propCoup;       /* Propriete du coup suite a la validation de l'arbitre */

    public TCodeRep getErr() {
        return err;
    }

    public void setErr(TCodeRep err) {
        this.err = err;
    }

    public TValCoup getValidCoup() {
        return validCoup;
    }

    public void setValidCoup(TValCoup validCoup) {
        this.validCoup = validCoup;
    }

    public TPropCoup getPropCoup() {
        return propCoup;
    }

    public void setPropCoup(TPropCoup propCoup) {
        this.propCoup = propCoup;
    }
}
