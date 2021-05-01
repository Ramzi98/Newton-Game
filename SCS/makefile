# For Solaris
#LD_FLAGS = -lsocket -lnsl

# For Linux
LD_FLAGS =

all: fonctionsTCP serveur 

fonctionsTCP: fonctionsTCP.c fonctionsTCP.h
	gcc -Wall -c fonctionsTCP.c -o fonctionsTCP.o

serveur: serveur.c fonctionsTCP.o newton.o
	gcc -Wall serveur.c -o serveur fonctionsTCP.o newton.o

clean:
	rm *~ ; rm -i \#* ; rm *.o; \
        rm clientTCP ; rm serveurTCP;

