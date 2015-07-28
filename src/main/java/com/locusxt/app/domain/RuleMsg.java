package com.locusxt.app.domain;

public class RuleMsg {
	String type;
	String rule;
	int ruleId;
	
	public String getType(){
		return type;
	}
	
	
	public void setType(String type){
		this.type = type;
	}
	
	public String getRule(){
		return rule;
	}
	
	public void setRule(String rule){
		this.rule = rule;
	}
	
	public int getRuleId(){
		return this.ruleId;
	}
	
	public void setRuleId(int ruleId){
		this.ruleId = ruleId;
	}
	
	public RuleMsg(){
		
	}
}
