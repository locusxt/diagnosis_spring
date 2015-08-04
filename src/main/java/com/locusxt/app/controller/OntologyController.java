package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/ontology")
public class OntologyController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String diagnosis(ModelMap model) {
		return "ontologymanager_2";
	}
}
