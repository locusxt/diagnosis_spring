package com.locusxt.app.domain;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.List;

public class DelRule {
	String rule;
	int ruleId;
	String targetFile;
	
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
	
	public void delete(){
		System.out.println("delete...");
		File f1 = new File(targetFile);
		File f2 = new File(targetFile + ".comment");
		try{
			FileReader fr1 = new FileReader(f1);
			FileReader fr2 = new FileReader(f2);
			LineNumberReader lnr1 = new LineNumberReader(fr1);
			LineNumberReader lnr2 = new LineNumberReader(fr2);
			
			String str1 = null, str2 = null;
			lnr1.setLineNumber(1);
			lnr2.setLineNumber(1);
			
			List <String> list1 = new ArrayList<String>();
			List <String> list2 = new ArrayList<String>();
			while ((str1 = lnr1.readLine()) != null){
				str2 = lnr2.readLine();
				int num = lnr1.getLineNumber();
				if (this.ruleId != num || !this.rule.equals(str1)){
					list1.add(str1);
					list2.add(str2);
					//System.out.println(lnr1.getLineNumber() + ":" +  str1 + " //" + str2);
				}
				else{
					System.out.println(num + ":" + this.ruleId);
					System.out.println(str1);
					System.out.println(this.rule);
				}
			}
			String[] rules = list1.toArray(new String[0]);
			String[] comments = list2.toArray(new String[0]);
			
			FileWriter fw1 = null;
			FileWriter fw2 = null;
			BufferedWriter bw1 = null;
			BufferedWriter bw2 = null;
			int num = rules.length;
			fw1 = new FileWriter(f1);
			bw1 = new BufferedWriter(fw1);
			fw2 = new FileWriter(f2);
			bw2 = new BufferedWriter(fw2);
			for (int i = 0; i < num; ++i){
				bw1.write(rules[i]);
				bw1.newLine();
				bw2.write(comments[i]);
				bw2.newLine();
			}
			bw1.flush();
			bw2.flush();
			
			bw1.close();
			bw2.close();
			lnr1.close();
			lnr2.close();
		}
		catch(IOException e){
			e.printStackTrace();
		}
	}
	
	public DelRule(){
		this.targetFile = "a.rules";
	}
}
