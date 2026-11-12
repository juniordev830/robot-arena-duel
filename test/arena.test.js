"use strict";
const test=require("node:test");
const assert=require("node:assert/strict");
const {criarRobo,atacar,reiniciar}=require("../src/arena");
test("dano e estado original",()=>{
  const a=criarRobo({nome:"A",dano:30});
  const b=criarRobo({nome:"B",vidaMaxima:50});
  const r=atacar(a,b,100);
  assert.equal(r.defensor.vida,20);
  assert.equal(b.vida,50);
  assert.equal(r.atacante.ultimoAtaqueEm,100);
  assert.equal(a.ultimoAtaqueEm,null);
});
test("recarga impede duplicar golpe",()=>{
  const a=criarRobo({nome:"A",dano:10,recargaMs:500}),b=criarRobo({nome:"B"});
  const primeiro=atacar(a,b,50);
  const repetido=atacar(primeiro.atacante,primeiro.defensor,50);
  assert.equal(repetido.sucesso,false);
  assert.equal(repetido.motivo,"recarga");
  assert.strictEqual(repetido.defensor,primeiro.defensor);
  assert.equal(atacar(primeiro.atacante,primeiro.defensor,549).sucesso,false);
  assert.equal(atacar(primeiro.atacante,primeiro.defensor,550).defensor.vida,80);
});
test("vida nunca é negativa e duelo termina",()=>{
  const a=criarRobo({nome:"A",dano:90}),b=criarRobo({nome:"B",vidaMaxima:60});
  const r=atacar(a,b,10);
  assert.equal(r.defensor.vida,0);
  assert.equal(r.motivo,"vitoria");
  assert.equal(atacar(r.atacante,r.defensor,1000).motivo,"duelo_encerrado");
});
test("reinício restaura atributos",()=>{
  const a=criarRobo({nome:"A",vidaMaxima:80});
  const b=criarRobo({nome:"B",dano:30});
  const novo=reiniciar(atacar(b,a,100).defensor);
  assert.equal(novo.vida,80);
  assert.equal(novo.ultimoAtaqueEm,null);
});
test("entradas inválidas e tempo retroativo",()=>{
  assert.throws(()=>criarRobo({nome:" "}),RangeError);
  assert.throws(()=>criarRobo({nome:"A",dano:0}),RangeError);
  const a=criarRobo({nome:"A"}),b=criarRobo({nome:"B"});
  assert.throws(()=>atacar(a,a,0),RangeError);
  assert.throws(()=>atacar(a,b,NaN),RangeError);
  const r=atacar(a,b,100);
  assert.throws(()=>atacar(r.atacante,r.defensor,99),RangeError);
});
