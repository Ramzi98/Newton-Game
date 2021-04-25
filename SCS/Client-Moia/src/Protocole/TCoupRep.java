package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

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

    @Override
    public int size() {
        return 12;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        byte[] err_bytes = intToBytes(err.ordinal());
        byte[] validCoup_bytes = intToBytes(validCoup.ordinal());
        byte[] propCoup_bytes = intToBytes(propCoup.ordinal());

        buffer.put(err_bytes);
        buffer.put(validCoup_bytes);
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
        err = readEnumuration(buffer, TCodeRep.class);
        validCoup = readEnumuration(buffer, TValCoup.class);
        propCoup = readEnumuration(buffer, TPropCoup.class);
    }
}
