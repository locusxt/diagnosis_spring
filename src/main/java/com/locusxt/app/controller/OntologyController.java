package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.locusxt.app.domain.MyOntology;
import com.locusxt.app.domain.RuleMsg;

@Controller
@RequestMapping("/ontology")
public class OntologyController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String diagnosis(ModelMap model) {
		return "ontologymanager_2";
	}
	
	@RequestMapping(value = "/ajax/post_ontology", method = RequestMethod.POST)
	public @ResponseBody RuleMsg updateOntology(@RequestBody MyOntology onto){
		
	}
}
