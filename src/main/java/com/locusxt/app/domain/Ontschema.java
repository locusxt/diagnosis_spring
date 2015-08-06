package com.locusxt.app.domain;

public class Ontschema {
	String subject;
	String property;
	String object;
	
	public void setSubject(String subject){
		this.subject = subject;
	}
	
	public String getSubject(){
		return this.subject;
	}
	
	public void setProperty(String property){
		this.property = property;
	}
	
	public String getProperty(){
		return this.property;
	}
	
	public void setObject(String object){
		this.object = object;
	}
	
	public String getObject(){
		return this.object;
	}
}
