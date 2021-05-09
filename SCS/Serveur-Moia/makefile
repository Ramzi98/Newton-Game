# For Solaris
#LD_FLAGS = -lsocket -lnsl

# For Linux
LD_FLAGS = -fPIC

all: fonctionTcp serveur 

fonctionTcp: fonctionTcp.c fonctionTcp.h
	gcc -Wall -c fonctionTcp.c -o fonctionTcp.o $(LD_FLAGS)

serveur: serveur.c fonctionTcp.o newton-fPIC.o
	gcc -Wall serveur.c -o serveur fonctionTcp.o newton-fPIC.o $(LD_FLAGS)

clean:
	rm *~ ; rm -i \#* ; rm *.o; \
        rm serveur;

