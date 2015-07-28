package com.locusxt.app.domain;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.List;

public class Rules {
	String rules[];
	String comments[];
	String targetFile;
	int partId;
	int partSize;
	
	public void setRules(String rules[]){
		this.rules = rules;
	}
	
	public String[] getRules(){
		return this.rules;
	}
	
	public void setComments(String comments[]){
		this.comments = comments;
	}
	
	public String[] getComments(){
		return this.comments;
	}
	
	public void setPartId(int partID){
		this.partId = partID;
	}
	
	public int getPartId(){
		return this.partId;
	}
	
	public void setPartSize(int partSize){
		this.partSize = partSize;
	}
	
	public int getPartSize(){
		return this.partSize;
	}
	
	public void updateRules(int partId, int partSize){
		this.partId = partId;
		this.partSize = partSize;
		File f1 = new File(targetFile);
		File f2 = new File(targetFile + ".comment");
		try{
			FileReader fr1 = new FileReader(f1);
			FileReader fr2 = new FileReader(f2);
			LineNumberReader lnr1 = new LineNumberReader(fr1);
			LineNumberReader lnr2 = new LineNumberReader(fr2);
			
			String str1 = null, str2 = null;
			lnr1.setLineNumber(partId);
			lnr2.setLineNumber(partId);
			
			List <String> list1 = new ArrayList<String>();
			List <String> list2 = new ArrayList<String>();
			while ((str1 = lnr1.readLine()) != null){
				str2 = lnr2.readLine();
				list1.add(str1);
				list2.add(str2);
				System.out.println(str1 + " //" + str2);
				if (lnr1.getLineNumber() > partId + partSize){
					break;
				}
			}
			this.rules = list1.toArray(new String[0]);
			this.comments = list2.toArray(new String[0]);
			lnr1.close();
			lnr2.close();
		}
		catch(IOException e){
			e.printStackTrace();
		}
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
					e1.printStackTrace();
				}
			}
		}
		return rules;
	}
	
	public Rules(){
		this.targetFile = "a.rules";
		this.rules = new String[]{"r1", "r2", "r3"};
	}
	
	public Rules(String targetFile){
		this.targetFile = targetFile;
	}
	
	public static void main(String[] args){
		Rules r = new Rules("a.rules");
		r.updateRules(0, 10);
		
	}
}
