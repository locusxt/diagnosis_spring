package com.locusxt.app.domain;

public class NewRule {
	String[] rules;
	String[] comments;
	
	public void setRules(String[] rules){
		this.rules = rules;
	}
	
	public String[] getRules(){
		return this.rules;
	}
	
	public void setComments(String[] comments){
		this.comments = comments;
	}
	
	public String[] getComments(){
		return this.comments;
	}
	
	public NewRule(){
		
	}
}
