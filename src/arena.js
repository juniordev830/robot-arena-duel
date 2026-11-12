"use strict";
function criarRobo({nome, vidaMaxima=100, dano=20, recargaMs=800}) {
  if (typeof nome !== "string" || !nome.trim() || nome.trim().length>60) throw new RangeError("Nome inválido.");
  if (![vidaMaxima,dano,recargaMs].every(Number.isSafeInteger)
    || vidaMaxima<1 || vidaMaxima>10000 || dano<1 || dano>10000
    || recargaMs<1 || recargaMs>600000) throw new RangeError("Atributos inválidos.");
  return Object.freeze({nome:nome.trim(),vidaMaxima,vida:vidaMaxima,dano,recargaMs,ultimoAtaqueEm:null});
}
function atacar(atacante, defensor, instanteMs) {
  if(!Number.isSafeInteger(instanteMs)||instanteMs<0)throw new RangeError("Tempo inválido.");
  if(atacante===defensor||atacante.nome===defensor.nome)throw new RangeError("Robôs devem ser diferentes.");
  if(atacante.vida<=0||defensor.vida<=0)
    return Object.freeze({sucesso:false,motivo:"duelo_encerrado",atacante,defensor});
  if(atacante.ultimoAtaqueEm!==null) {
    if(instanteMs<atacante.ultimoAtaqueEm)throw new RangeError("Tempo retroativo.");
    if(instanteMs-atacante.ultimoAtaqueEm<atacante.recargaMs)
      return Object.freeze({sucesso:false,motivo:"recarga",atacante,defensor});
  }
  const novoAtacante=Object.freeze({...atacante,ultimoAtaqueEm:instanteMs});
  const novoDefensor=Object.freeze({...defensor,vida:Math.max(0,defensor.vida-atacante.dano)});
  return Object.freeze({sucesso:true,motivo:novoDefensor.vida===0?"vitoria":"acerto",atacante:novoAtacante,defensor:novoDefensor});
}
function reiniciar(robo) {
  return criarRobo({nome:robo.nome,vidaMaxima:robo.vidaMaxima,dano:robo.dano,recargaMs:robo.recargaMs});
}
module.exports={criarRobo,atacar,reiniciar};
