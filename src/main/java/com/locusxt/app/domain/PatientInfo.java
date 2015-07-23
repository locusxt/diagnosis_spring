package com.locusxt.app.domain;

public class PatientInfo {
	String name;
	String gender;
	String id;
	String office;
	int age;
	
	String complaint[];
	String complaintTime[];
	String phyExam[];
	String phyExamResult[];
	
	public void setName(String name){this.name = name;}
	
	public String getName(){return this.name;}
	
	public void setGender(String gender){this.gender = gender;}
	
	public String getGender(){return this.gender;}
	
	public void setId(String id){this.id = id;}
	
	public String getId(){return this.id;}
	
	public void setOffice(String office){this.office = office;}
	
	public String getOffice(){return this.office;}
	
	public void setAge(int age){this.age = age;}
	
	public int getAge(){return age;}
	
	public void setComplaint(String complaint[]){this.complaint = complaint;}
	
	public String[] getComplaint(){return this.complaint;}
	
	public void setComplaintTime(String complaintTime[]){this.complaintTime = complaintTime;}
	
	public String[] getComplaintTime(){return this.complaintTime;}
	
	public void setPhyExam(String phyExam[]){this.phyExam = phyExam;}
	
	public String[] getPhyExam(){return this.phyExam;}
	
	public void setPhyExamResult(String phyExamResult[]){this.phyExamResult = phyExamResult;}
	
	public String[] getPhyExamResult(){return this.phyExamResult;}
	
	public PatientInfo(){
		
	}
	
	public PatientInfo(String name, String gender, String id, String office, int age){
		this.name = name;
		this.gender = gender;
		this.id = id;
		this.office = office;
		this.age = age;
	}
	
	public void genPhyExam(){
		String[] strs = new String[3];
		strs[0] = "cough";
		strs[1] = "haha";
		strs[2] = "fever";
		this.setPhyExam(strs);
	}
	
}
