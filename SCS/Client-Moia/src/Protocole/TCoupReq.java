package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class TCoupReq extends Newton{
    private TIdReq     idRequest;     /* Identificateur de la requete */
    private int        numPartie;     /* Numero de la partie (commencant a 1) */
    private TCoup      typeCoup;      /* Type coup */
    private TPosPion  posePion;
    private TDeplPion deplPion;
    private TPropCoup  propCoup;      /* Propriete du coup proposee par le joueur */

    public TCoupReq(TIdReq idRequest, int numPartie, TCoup typeCoup, TPosPion posePion, TDeplPion deplPion, TPropCoup propCoup) {
        this.idRequest = idRequest;
        this.numPartie = numPartie;
        this.typeCoup = typeCoup;
        this.posePion = posePion;
        this.propCoup = propCoup;
        this.deplPion = deplPion;
    }


    public TCoupReq() {

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

    public TPropCoup getPropCoup() {
        return propCoup;
    }

    public void setPropCoup(TPropCoup propCoup) {
        this.propCoup = propCoup;
    }

    @Override
    public int size() {
        return 28;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] idRequest_bytes = intToBytes(idRequest.ordinal());
        byte[] numPartie_bytes = intToBytes(numPartie);
        byte[] typeCoup_bytes = intToBytes(typeCoup.ordinal());
        byte[] propCoup_bytes = intToBytes(propCoup.ordinal());

        buffer.put(idRequest_bytes);
        buffer.put(numPartie_bytes);
        buffer.put(typeCoup_bytes);
        if(typeCoup == TCoup.POSE)
        {
            posePion.putInBuffer(buffer);
        }
        else
        {
            deplPion.putInBuffer(buffer);
        }
        buffer.put(propCoup_bytes);

    }

    @Override
    public void send(OutputStream os) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(size());
        putInBuffer(buffer);
        os.write(buffer.flip().array());
    }

    @Override
    public void recive(InputStream is) throws IOException {
        byte[] bytes = new byte[size()];
        is.read(bytes);
        ByteBuffer buffer = ByteBuffer.allocate(size()).put(bytes).flip();
        getFromBuffer(buffer);

    }

    @Override
    public void getFromBuffer(ByteBuffer buffer) throws IOException {
        idRequest = readEnumuration(buffer, TIdReq.class);
        numPartie = readIntBytes(buffer);
        typeCoup = readEnumuration(buffer, TCoup.class);
        if(typeCoup == TCoup.POSE)
        {
            posePion = new TPosPion();
            posePion.getFromBuffer(buffer);
        }
        else
        {
            deplPion = new TDeplPion();
            deplPion.getFromBuffer(buffer);
        }
        propCoup = readEnumuration(buffer, TPropCoup.class);
    }
}
