package com.locusxt.app.domain;

public class PatientInfo {
	String name;
	String gender;
	String id;
	String office;
	int age;
	
	public void setName(String name){
		this.name = name;
	}
	
	public String getName(){
		return this.name;
	}
	
	public void setGender(String gender){
		this.gender = gender;
	}
	
	public String getGender(){
		return this.gender;
	}
	
	public void setId(String id){
		this.id = id;
	}
	
	public String getId(){
		return this.id;
	}
	
	public void setOffice(String office){
		this.office = office;
	}
	
	public String getOffice(){
		return this.office;
	}
	
	public void setAge(int age){
		this.age = age;
	}
	
	public int getAge(){
		return age;
	}
	
	public PatientInfo(){
		
	}
	
	public PatientInfo(String name, String gender, String id, String office, int age){
		this.name = name;
		this.gender = gender;
		this.id = id;
		this.office = office;
		this.age = age;
	}
}
