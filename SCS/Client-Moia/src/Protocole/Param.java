package Protocole;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;

public class Param extends Newton{
    private TPosPion  posePion;
    private TDeplPion deplPion;

    public Param(TPosPion posePion, TDeplPion deplPion) {
        this.posePion = posePion;
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

    @Override
    public int size() {
        return 24;
    }

    @Override
    public void putInBuffer(ByteBuffer buffer) {
        posePion.putInBuffer(buffer);
        deplPion.putInBuffer(buffer);
    }

    @Override
    public void send(OutputStream os) throws IOException {
        ByteBuffer buffer = ByteBuffer.allocate(size());
        putInBuffer(buffer);
        os.write(buffer.flip().array());
    }

    @Override
    public void recive(InputStream is) throws IOException {
        posePion.recive(is);
        deplPion.recive(is);
    }
}
