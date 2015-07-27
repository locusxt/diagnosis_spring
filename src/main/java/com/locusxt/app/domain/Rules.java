package com.locusxt.app.domain;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

public class Rules {
	String rules[];
	String targetFile;
	
	public void setRules(String rules[]){
		this.rules = rules;
	}
	
	public String[] getRules(){
		return this.rules;
	}
	
	public String[] list_rules(){
		File file = new File(targetFile);
		BufferedReader reader = null;
		try{
			reader = new BufferedReader(new FileReader(file));
			String tmpStr = null;
			while((tmpStr = reader.readLine())!= null){
				System.out.println(tmpStr);
			}
			reader.close();
		}
		catch (IOException e) {
			e.printStackTrace();
		}
		finally{
			if (reader != null){
				try{
					reader.close();
				}
				catch (IOException e1){
					
				}
			}
		}
		return rules;
	}
	
	public Rules(){
		this.targetFile = "rules1.rules";
		this.rules = new String[]{"r1", "r2", "r3"};
	}
	
	public Rules(String targetFile){
		this.targetFile = targetFile;
	}
	
	public static void main(String[] args){
		Rules r = new Rules("rules1.rules");
		r.list_rules();
		
	}
}
