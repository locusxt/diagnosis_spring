package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.locusxt.app.domain.NewRule;
import com.locusxt.app.domain.ResponseMsg;
import com.locusxt.app.domain.RuleMsg;
import com.locusxt.app.domain.Rules;

@Controller
@RequestMapping("/rule")
public class RuleController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String diagnosis(ModelMap model) {
		return "rulemanager_3";
	}
	
	@RequestMapping(value = "/ajax/get_rules", method = RequestMethod.POST)
	public @ResponseBody Rules getRules(@RequestBody Rules rules){
		rules.updateRules(rules.getPartId(), rules.getPartSize());
		return rules;
	}
	
	@RequestMapping(value = "/ajax/post_new_rule", method = RequestMethod.POST)
	public @ResponseBody ResponseMsg postNewRule(@RequestBody NewRule newRule){
		System.out.println(newRule.getRules()[0]);
		newRule.save();
		return new ResponseMsg("ok");
	}
}
