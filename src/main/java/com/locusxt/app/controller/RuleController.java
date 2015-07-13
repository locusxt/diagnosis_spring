package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/rule")
public class RuleController {
	@RequestMapping(value="/", method = RequestMethod.GET)
    public String diagnosis(ModelMap model) {
        return "rulemanager";
    }
}
