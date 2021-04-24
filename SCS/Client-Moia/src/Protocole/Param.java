package Protocole;

public class Param extends Newton{
    private TPosPion  posePion;
    private TDeplPion deplPion;

    public Param(TPosPion posePion) {
        this.posePion = posePion;
    }

    public Param(TDeplPion deplPion) {
        this.deplPion = deplPion;
    }

    public TPosPion getPosePion() {
        return posePion;
    }

    public void setPosePion(TPosPion posePion) {
        this.posePion = posePion;
    }

    public TDeplPion getDeplPion() {
        return deplPion;
    }

    public void setDeplPion(TDeplPion deplPion) {
        this.deplPion = deplPion;
    }
}
