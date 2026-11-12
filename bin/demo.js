"use strict";
const {criarRobo,atacar}=require("../src/arena");
let alpha=criarRobo({nome:"Alpha",dano:35,recargaMs:500});
let beta=criarRobo({nome:"Beta",vidaMaxima:80,dano:20});
for(const tempo of [0,500,1000]){
  const r=atacar(alpha,beta,tempo);
  alpha=r.atacante;beta=r.defensor;
  console.log(tempo+"ms: "+alpha.nome+" → "+beta.nome+": "+beta.vida+"/"+beta.vidaMaxima);
  if(beta.vida===0)break;
}
console.log(beta.vida===0?"Duelo encerrado.":"Duelo continua.");
