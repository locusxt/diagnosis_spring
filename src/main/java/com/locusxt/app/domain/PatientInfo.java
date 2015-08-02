package com.locusxt.app.domain;


public class PatientInfo {
	String name;
	String gender;
	String id;
	String office;
	int age;
	
	String complaint[];
	String complaintTime[];
	String complaintDegree[];
	String recommendPhyExam[];
	String phyExam[];
	String phyExamResult[];
	String recommendTest[];
	String test[];
	String testResult[];
	String possibleDisease[];
	String advice[];
	
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
	
	public void setComplaintDegree(String complaintDegree[]){this.complaintDegree = complaintDegree;}
	
	public String[] getComplaintDegree(){return this.complaintDegree;}
	
	public void setRecommendPhyExam(String recommendPhyExam[]){this.recommendPhyExam = recommendPhyExam;}
	
	public String[] getRecommendPhyExam(){return this.recommendPhyExam;}
	
	public void setPhyExam(String phyExam[]){this.phyExam = phyExam;}
	
	public String[] getPhyExam(){return this.phyExam;}
	
	public void setPhyExamResult(String phyExamResult[]){this.phyExamResult = phyExamResult;}
	
	public String[] getPhyExamResult(){return this.phyExamResult;}
	
	public void setRecommendTest(String recommendTest[]){this.recommendTest = recommendTest;}
	
	public String[] getRecommendTest(){return this.recommendTest;}
	
	public void setTest(String test[]){this.test = test;}
	
	public String[] getTest(){return this.test;}
	
	public void setTestResult(String testResult[]){this.testResult = testResult;}
	
	public String[] getTestResult(){return this.testResult;}
	
	public void setPossibleDisease(String[] possibleDisease){this.possibleDisease = possibleDisease;}
	
	public String[] getPossibleDisease(){return this.possibleDisease;}
	
	public void setAdvice(String advice[]){this.advice = advice;}
	
	public String[] getAdvice(){return this.advice;}
	
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
	
	public void update(){
		this.possibleDisease = new String[]{"感冒", "肺炎"};
		this.phyExam = new String[]{"体温", "e1"};
	}
	
}
