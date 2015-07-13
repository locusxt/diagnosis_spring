package com.locusxt.app.domain;

public class Complaints {
	String name;
	String complaintList[];
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String[] getComplaintList(){
		return complaintList;
	}
	public void setComplaintList(String[] complaintList) {
		this.complaintList = complaintList;
	}
	public Complaints() {
		setName("complaintsList");
		setComplaintList(new String[]{"fever", "headache", "toothache"});
	} 
}
