#include "fonctionTcp.h"
#include "protocolNewton.h"
#include "validation.h"
#include "time.h"

#define TIME_MAX 6000;

int main(int argc, char** argv) {
  int  sockConx,        /* descripteur socket connexion */
       sockTrans1,   
       sockTrans2,    /* descripteur socket transmission */
       port,            /* numero de port */
       sizeAddr,        /* taille de l'adresse d'une socket */
       err,
       nfsd;
       fd_set readSet;

 struct timeval tv;
tv.tv_sec = TIME_MAX;
tv.tv_usec = 0;

  TIdReq codeReq;
  
  TCoupReq reqCoup;
  TCoupRep repCoup;
  TPartieReq reqPartie;
  TPartieRep repPartieJ1, repPartieJ2;
  TPropCoup *propCoup;

  int numPartie = 1;
  char nomJoueur1[T_NOM];
  char nomJoueur2[T_NOM];

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



  sockTrans1 = accept(sockConx, NULL, NULL);
  sockTrans2 = accept(sockConx, NULL, NULL);

  if (sockTrans1 < 0) { /* erreur … */ }
  if (sockTrans2 < 0) { /* erreur … */ }


  if (err < 0) {
      perror("(serveurSelect) erreur dans select");
      /* shutdown + close */
  }

  FD_ZERO(&readSet) ;  // initialisation à zéro
  FD_SET(sockTrans1, &readSet);
  FD_SET(sockTrans2, &readSet);

  

    err = recv(sockTrans1, &codeReq, sizeof(TIdReq), MSG_PEEK);
    if (err < 0 ) 
    perror("(serveurSelect) erreur dans le recv 1");

    switch(codeReq){

        case PARTIE : 
        
        err = recv(sockTrans1, &reqPartie,sizeof(TPartieReq), 0);
            repPartieJ1.err = ERR_OK;
            repPartieJ1.coulPion = BLEU;
            memcpy(nomJoueur1, reqPartie.nomJoueur, T_NOM );  
            break;

      
        default : 
        repPartieJ1.err = ERR_TYP;
        break;
    }

    
    err = recv(sockTrans2, &codeReq, sizeof(TIdReq), MSG_PEEK);
    if (err < 0 ) 
    perror("(serveurSelect) erreur dans le recv 1");

    switch(codeReq){

        case PARTIE : 
        
        err = recv(sockTrans2,&reqPartie,sizeof(TPartieReq), 0);
            repPartieJ2.err = ERR_OK;
            repPartieJ2.coulPion = ROUGE;
            memcpy(nomJoueur2, reqPartie.nomJoueur, T_NOM );  
            break;


      default : 

        repPartieJ2.err = ERR_TYP;
        break;
    }
  
      initialiserPartie();
      memcpy(repPartieJ1.nomAdvers, nomJoueur2, T_NOM );  
      memcpy(repPartieJ1.nomAdvers, nomJoueur2, T_NOM );  
      err = send(sockTrans1, &repPartieJ1, sizeof(TPartieRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }

      err = send(sockTrans2, &repPartieJ2, sizeof(TPartieRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }


    if(numPartie == 1){

     while(1){

          int retval = select(nfsd, &sockTrans1, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }
          err = recv(sockTrans1, &codeReq,sizeof( TIdReq), MSG_PEEK);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
            return -5;

          }
          switch(codeReq){
          case COUP: 

         retval = select(nfsd, &sockTrans1, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }
          err = recv(sockTrans1, &reqCoup,sizeof(TCoupReq), 0);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
            return -5;

          }

      bool coupBool = validationCoup(1,reqCoup, &propCoup);
      if(coupBool == false && reqCoup.propCoup == CONT){
            
          repCoup.err = ERR_COUP;
          repCoup.validCoup = TRICHE;
          repCoup.propCoup = PERDU;

      err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }
          
            printf("Coup Non valide");

            break;
            /*
              Do something about the socket
            */
          }else{

          repCoup.err = ERR_OK;
          repCoup.validCoup = VALID;
          repCoup.propCoup = *propCoup;

      err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }
    }

      // envoie de la validité du coup au joueur 2 

      err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      if(coupBool == true && propCoup != CONT){

      //  printf("La partie est en etat %s",propCoup);
        break;
      }
      if(coupBool == true && reqCoup.propCoup == CONT){

      err = send(sockTrans2, &reqCoup, sizeof(TCoupReq) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      }
          break;

          default :
          

              repCoup.err = ERR_TYP;
              err = send(sockTrans1, &repCoup, sizeof(TCodeRep) , 0);
              if (err <= 0) { 
              perror("(serveurR) erreur sur le send");
              shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
              return -5;
              }
              break;

          }
      /*-------------- Recevoir le coup du joueur 2 ---------- */
    

         retval = select(nfsd, &sockTrans2, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }         
         err = recv(sockTrans2, &codeReq,sizeof(TIdReq), MSG_PEEK);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
            return -5;

          }

          switch(codeReq){
          case COUP: 

           retval = select(nfsd, &sockTrans2, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }
          err = recv(sockTrans2, &reqCoup,sizeof(TCoupReq), 0);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
            return -5;

          }

      bool coupBool = validationCoup(2,reqCoup, &propCoup);
      if(coupBool == false && reqCoup.propCoup == CONT){
            
          repCoup.err = ERR_COUP;
          repCoup.validCoup = TRICHE;
          repCoup.propCoup = PERDU;

          err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }
        printf("Coup Non valide, Joueur perdant");

      break;
        
      }else{
       repCoup.err = ERR_OK;
       repCoup.validCoup = VALID;
       repCoup.propCoup = *propCoup;

     err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }
      }
      

      // envoie de la validité du coup au joueur 1 

      err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      if(coupBool == true && reqCoup.propCoup == CONT){

      err = send(sockTrans1, &reqCoup, sizeof(TCoupReq) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }

      }
        



      
          break;

          default:
          

              repCoup.err = ERR_TYP;
              err = send(sockTrans2, &repCoup, sizeof(TCodeRep) , 0);
              if (err <= 0) { 
              perror("(serveurR) erreur sur le send");
              shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
              return -5;
              }
              break;
              break;

          
      
     }
     }
      numPartie++;
  
    }
  
    if(numPartie == 2){

      while(1){

         
        int retval = select(nfsd, &sockTrans2, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }

          err = recv(sockTrans2, &codeReq,sizeof(TIdReq), MSG_PEEK);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
            return -5;

          }

          switch(codeReq){
          case COUP :

         retval = select(nfsd, &sockTrans2, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }
          err = recv(sockTrans2, &reqCoup,sizeof(TCoupReq), 0);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
            return -5;

          }

      bool coupBool = validationCoup(2,reqCoup, &propCoup);
      if(coupBool == false && reqCoup.propCoup == CONT){
            
          repCoup.err = ERR_COUP;
          repCoup.validCoup = TRICHE;
          repCoup.propCoup = PERDU;

      err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }
          
            printf("Coup Non valide");

            break;
            /*
              Do something about the socket
            */
          }else{

          repCoup.err = ERR_OK;
          repCoup.validCoup = VALID;
          repCoup.propCoup = *propCoup;

      err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }
    }

      // envoie de la validité du coup au joueur 2 

      err = send(sockTrans2, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      if(coupBool == true && propCoup != CONT){

       // printf("La partie est en etat %c",propCoup);
        break;
      }
      if(coupBool == true && reqCoup.propCoup == CONT){

      err = send(sockTrans2, &reqCoup, sizeof(TCoupReq) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      }
          break;
          default:

              repCoup.err = ERR_TYP;
              err = send(sockTrans2, &repCoup, sizeof(TCodeRep) , 0);
              if (err <= 0) { 
              perror("(serveurR) erreur sur le send");
              shutdown(sockTrans2, SHUT_RDWR); close(&sockTrans2);
              return -5;
              }
              break;


          }
      /*-------------- Recevoir le coup du joueur 1 ---------- */
    

         retval = select(nfsd, &sockTrans1, NULL, NULL, &tv); 
                  if(retval <= 0 ){

                    printf("error");
                    /*send response timeout*/
                  }
          err = recv(sockTrans1, &codeReq,sizeof(TIdReq), MSG_PEEK);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
            return -5;

          }

          switch(codeReq){
          case COUP :

           retval = select(nfsd, &sockTrans1, NULL, NULL, &tv); 
          if(retval <= 0 ){

            printf("error");
            /*send response timeout*/
          }
          err = recv(sockTrans1, &reqCoup,sizeof(TCoupReq), 0);
          if(err <= 0){

            perror("(serveurR) erreur sur le send");
            shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
            return -5;

          }

      bool coupBool = validationCoup(1,reqCoup, &propCoup);
      if(coupBool == false && reqCoup.propCoup == CONT){
            
          repCoup.err = ERR_COUP;
          repCoup.validCoup = TRICHE;
          repCoup.propCoup = PERDU;

          err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }
        printf("Coup Non valide, Joueur perdant");

      break;
        
      }else{
       repCoup.err = ERR_OK;
       repCoup.validCoup = VALID;
       repCoup.propCoup = *propCoup;

     err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }
      }
      

      // envoie de la validité du coup au joueur 1 

      err = send(sockTrans1, &repCoup, sizeof(TCoupRep) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
      return -5;
      }

      if(coupBool == true && reqCoup.propCoup == CONT){

      err = send(sockTrans2, &reqCoup, sizeof(TCoupReq) , 0);
      if (err <= 0) { 
      perror("(serveurR) erreur sur le send");
      shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);
      return -5;
      }

      }
        
          //default:
          

              repCoup.err = ERR_TYP;
              err = send(sockTrans1, &repCoup, sizeof(TCodeRep) , 0);
              if (err <= 0) { 
              perror("(serveurR) erreur sur le send");
              shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
              return -5;
              }
              break;

          
      
     }

      }

    }

















    /* 
   * arret de la connexion et fermeture -- Tout a la fin du programme ! 
   */


  
  shutdown(sockTrans1, SHUT_RDWR); close(sockTrans1);
  shutdown(sockTrans2, SHUT_RDWR); close(sockTrans2);

  close(sockConx);
  
  
  return 0; 
}
    

