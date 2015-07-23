package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.locusxt.app.domain.Complaints;
import com.locusxt.app.domain.PatientInfo;
 
@Controller
@RequestMapping("/diagnosis")
public class DiagnosisController {
	@RequestMapping(value="/", method = RequestMethod.GET)
    public String diagnosis(ModelMap model) {
        return "diagnosis_3";
    }
	
	@RequestMapping(value="/old", method = RequestMethod.GET)
    public String diagnosisold(ModelMap model) {
        return "diagnosis";
    }
 
    @RequestMapping(value="/hello", method = RequestMethod.GET)
    public String sayHello(ModelMap model) {
        model.addAttribute("greeting", "Hello World from Spring 4 MVC");
        return "welcome";
    }
    
    @RequestMapping(value="/ajax/get_complaints", method = RequestMethod.GET)
	public @ResponseBody Complaints getComplaintsJSON() {
    	Complaints complaints = new Complaints();
    	//System.out.println("complaints");
    	return complaints;
	}
    
    @RequestMapping(value="/ajax/post_basicinfo", method = RequestMethod.POST)
	public @ResponseBody Complaints postBasicInfo(@RequestBody PatientInfo info) {
    	System.out.println(info.getName());
    	Complaints complaints = new Complaints();
    	//System.out.println("complaints");
    	return complaints;
	}
    
    @RequestMapping(value="/ajax/phy_exam", method = RequestMethod.POST)
    public @ResponseBody PatientInfo getPhyExam(@RequestBody PatientInfo info) {
    	System.out.println("patient info");
    	info.genPhyExam();
    	return info;
    }
}
