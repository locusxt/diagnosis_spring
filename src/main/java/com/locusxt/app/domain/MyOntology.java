package com.locusxt.app.domain;


public class MyOntology {
	ZNodes znodes[];
	Ontschema ontschema[];
	
	public void setZNodes(ZNodes znodes[]){
		this.znodes = znodes;
	}
	
	public ZNodes[] getZNodes(){
		return this.znodes;
	}
	
	public void setOntschema(Ontschema ontschema[]){
		this.ontschema = ontschema;
	}
	
	public Ontschema[] getOntschema(){
		return this.ontschema;
	}
}
