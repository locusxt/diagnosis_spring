package com.locusxt.app.domain;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;

public class NewRule {
	String[] rules;
	String[] comments;
	String targetFile;
	
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
	
	public void save(){
		File f1 = new File(targetFile);
		File f2 = new File(targetFile + ".comment");
		FileWriter fw1 = null;
		FileWriter fw2 = null;
		BufferedWriter bw1 = null;
		BufferedWriter bw2 = null;
		int num = rules.length;
		try{
			fw1 = new FileWriter(f1, true);
			bw1 = new BufferedWriter(fw1);
			fw2 = new FileWriter(f2, true);
			bw2 = new BufferedWriter(fw2);
			for (int i = 0; i < num; ++i){
				bw1.write(this.rules[i]);
				bw1.newLine();
				bw2.write(this.comments[i]);
				bw2.newLine();
			}
			bw1.flush();
			bw2.flush();
		}
		catch (FileNotFoundException e){
			e.printStackTrace();
		}
		catch (IOException e){
			e.printStackTrace();
		}
		finally{
			try{
				bw1.close();
				bw2.close();
				fw1.close();
				fw2.close();
			}
			catch (IOException e){
				e.printStackTrace();
			}
		}
	}
	
	public NewRule(){
		this.targetFile = "a.rules";
	}
	
	public NewRule(String targetFile){
		this.targetFile = targetFile;
	}
}
