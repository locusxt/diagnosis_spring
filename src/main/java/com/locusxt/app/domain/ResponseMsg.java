package com.locusxt.app.domain;

public class ResponseMsg {
	String msg;
	
	public void setMsg(String msg){
		this.msg = msg;
	}
	
	public String getMsg(){
		return msg;
	}
	
	public ResponseMsg(String msg){
		this.setMsg(msg);
	}
}
