#include "fonctionsTCP.h"
#include "protocolNewton.h"
#include "validation.h"



int main(int argc, char** argv) {
  int  sockConx,        /* descripteur socket connexion */
       sockTrans,       /* descripteur socket transmission */
       port,            /* numero de port */
       sizeAddr,        /* taille de l'adresse d'une socket */
       err;

  TCodeReq codeReq;
  TPartieReq reqPartie;
  TPartieRep repPartieJ1, repPartieJ2;
  int joueur1 = 0;
  int joueur2 = 0;
  char nomJoueur1[T_NOM];
  char nomJoueur1[T_NOM];

  struct sockaddr_in addClient;	/* adresse de la socket client connectee */
  

  
  /*
   * verification des arguments
   */
  if (argc != 2) {
    printf ("usage : %s port\n", argv[0]);
    return -1;
  }
  
  port  = atoi(argv[1]);
  
  sockConx = socketServeur(port);
  
  sizeAddr = sizeof(struct sockaddr_in);

  fd_set  readSet;


  sockTrans1 = accept(sockConx, NULL, NULL);
  if (sockTrans1 < 0) { /* erreur … */ }
  sockTrans2 = accept(sockConx, NULL, NULL);
  if (sockTrans2 < 0) { /* erreur … */ }
  

  FD_ZERO(&readSet);
  FD_SET(sockTrans1, &readSet);
  FD_SET(sockTrans2, &readSet);
  nfsd = 6;
  err = select(nfsd, &readSet, NULL, NULL, NULL);
  if (err < 0) {
      perror("(serveurSelect) erreur dans select");
      /* shutdown + close */
  }

  while(1){

  if (FD_ISSET(sockTrans1, &readSet) != 0) { 
     
    err = recv(sockTrans1, &codeReq, sizeof(TCodeReq), 0);
    if (err < 0 ) 
    perror("(serveurSelect) erreur dans le recv 1");

    switch(codeReq){

        case PARTIE : 
        
        err = recv(sockTrans1, &reqPartie,sizeof(TPartieReq), 0);

        if(joueur1 == 0){
            joueur1 = 1;
            repPartieJ1.err = ERR_OK;
            repPartieJ1.coulPion = BLEU;
            nomJoueur1 = reqPartie.nomJoueur;
        }
        break;
    }
  }


   if (FD_ISSET(sockTrans2, &readSet) != 0) { 
     
    err = recv(sockTrans2, &codeReq, sizeof(TCodeReq), 0);
    if (err < 0 ) 
    perror("(serveurSelect) erreur dans le recv 1");

    switch(codeReq){

        case PARTIE : 
        
        err = recv(sockTrans1, &reqPartie,sizeof(TPartieReq), 0);

        if(joueur1 == 1){
            joueur2 = 1;
            repPartieJ2.err = ERR_OK;
            repPartieJ2.coulPion = ROUGE;
            nomJoueur2 = reqPartie.nomJoueur;
        }
        break;
    }
  }


  if(joueur1 == 1 && joueur2 == 1){
      initialiserPartie();
      repPartieJ1.nomAdvers = nomJoueur2;
      repPartieJ2.nomAdvers = nomJoueur1;
     err = send(sockTrans1, repPartieJ1, sizeof(TPartieRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans, SHUT_RDWR); close(sockTrans);
      return -5;
      }

      err = send(sockTrans2, repPartieJ2, sizeof(TPartieRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans, SHUT_RDWR); close(sockTrans);
      return -5;
      }

  }
}
    /* 
   * arret de la connexion et fermeture
   */
  shutdown(sockTrans, SHUT_RDWR); close(sockTrans);
  close(sockConx);
  
  
  return 0; 
}
