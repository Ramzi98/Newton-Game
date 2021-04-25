package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

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

    @Override
    public int size() {
        return 40;
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
        param.putInBuffer(buffer);
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
        is.readNBytes(bytes, 0, size());

        ByteBuffer buffer = ByteBuffer.allocate(size()).put(bytes).flip();

        idRequest = readEnumuration(buffer, TIdReq.class);
        numPartie = readInt(is);
        typeCoup = readEnumuration(buffer, TCoup.class);
        param.recive(is);
        propCoup = readEnumuration(buffer, TPropCoup.class);
    }
}
