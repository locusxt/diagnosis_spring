package com.locusxt.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.locusxt.app.domain.ResponseMsg;
import com.locusxt.app.domain.RuleMsg;

@Controller
@RequestMapping("/rule")
public class RuleController {
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String diagnosis(ModelMap model) {
		return "rulemanager_3";
	}

	@RequestMapping(value = "/ajax/ruleManage", method = RequestMethod.POST)
	public @ResponseBody ResponseMsg manageRule(@RequestBody RuleMsg msg) {
		System.out.println(msg.getType());
		System.out.println(msg.getRule());
		return new ResponseMsg("ok");
	}
}
