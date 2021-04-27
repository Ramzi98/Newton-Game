# For Solaris
#LD_FLAGS = -lsocket -lnsl

# For Linux
LD_FLAGS =

all: fonctionsTCP serveur protocolNewton

fonctionsTCP: fonctionsTCP.c fonctionsTCP.h
	gcc -Wall -c fonctionsTCP.c -o fonctionsTCP.o

serveur: serveur.c fonctionsTCP fctClCalc
	gcc -Wall clientTCP.c -o clientTCP fonctionsTCP.o fctClCalc.o

serveurTCP: serveurTCP.c fonctionsTCP fctServCalc
	gcc -Wall serveurTCP.c -o serveurTCP fonctionsTCP.o 

serveurR: serveurR.c fonctionsTCP 
	gcc -Wall serveurR.c -o serveurR fonctionsTCP.o 

fctClCalc: fctClCalc.c fctClCalc.h
	gcc -Wall -c fctClCalc.c -o fctClCalc.o  

fctServCalc: fctServCalc.c fctServCalc.h
	gcc -Wall -c fctServCalc.c -o fctServCalc.o 

clean:
	rm *~ ; rm -i \#* ; rm *.o; \
        rm clientTCP ; rm serveurTCP;

