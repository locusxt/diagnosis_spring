package com.locusxt.app.domain;


public class MyOntology {
	ZNodes zNodes[];
	Ontschema ontschema[];
	
	public void setZNodes(ZNodes zNodes[]){
		this.zNodes = zNodes;
	}
	
	public ZNodes[] getZNodes(){
		return this.zNodes;
	}
	
	public void setOntschema(Ontschema ontschema[]){
		this.ontschema = ontschema;
	}
	
	public Ontschema[] getOntschema(){
		return this.ontschema;
	}
}
