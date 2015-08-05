package com.locusxt.app.jena;

import java.util.ArrayList;
import java.util.List;

import com.hp.hpl.jena.ontology.DatatypeProperty;
import com.hp.hpl.jena.ontology.ObjectProperty;
import com.hp.hpl.jena.ontology.OntClass;
import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.ontology.OntModelSpec;
import com.hp.hpl.jena.rdf.model.InfModel;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Property;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.Statement;
import com.hp.hpl.jena.rdf.model.StmtIterator;
import com.hp.hpl.jena.reasoner.Reasoner;
import com.hp.hpl.jena.reasoner.rulesys.GenericRuleReasoner;
import com.hp.hpl.jena.reasoner.rulesys.Rule;
import com.hp.hpl.jena.sparql.pfunction.library.listIndex;
import com.hp.hpl.jena.util.PrintUtil;
import com.locusxt.app.domain.PatientInfo;

public class JenaReasoner {
	public static String defaultNameSpace="http://somewhere/";
	public static OntModel mData;
	
	private String removePrefix(String str){
		int i = str.lastIndexOf('/');
		return str.substring(i + 1);
	}
	
	public void mytest(PatientInfo info){
		System.out.println("test");
		List rules = Rule.rulesFromURL("file:a.rules");
		System.out.println(rules.size());
		Reasoner reasoner = new GenericRuleReasoner(rules);
		InfModel infmodel = ModelFactory.createInfModel(reasoner, mData);
		
		
		// Query for all things related to "a" by "p"
		Property p = mData.getProperty(defaultNameSpace, "hasdiseaseof");
		//Resource a = mData.getResource(defaultNameSpace + "a");
		StmtIterator i = infmodel.listStatements(null, p, (RDFNode)null);
		
		List<String> diseaseList = new ArrayList<String>();
		while (i.hasNext()) {
		    //System.out.println(" - " + PrintUtil.print(i.nextStatement()));
		    Statement stmt = i.nextStatement();
		    diseaseList.add(removePrefix(stmt.getObject().toString()));
			System.out.println(removePrefix(stmt.getObject().toString()));
		}
		info.setPossibleDisease(diseaseList.toArray(new String[1]));
		
		p = mData.getProperty(defaultNameSpace, "get_advice_of");
		i = infmodel.listStatements(null, p, (RDFNode)null);
		List<String> testList = new ArrayList<String>();
		while(i.hasNext()){
			Statement stmt = i.nextStatement();
			testList.add(removePrefix(stmt.getObject().toString()));
			System.out.println(removePrefix(stmt.getObject().toString()));
		}
		info.setTest(testList.toArray(new String[1]));
	}
	
	public void genDatamodel(PatientInfo info){
		mData=ModelFactory.createOntologyModel(OntModelSpec.OWL_DL_MEM);
		OntClass ont = mData.createClass(defaultNameSpace + info.getName());
		int complaintNum = info.getComplaint().length;
		OntClass complaint[] = new OntClass[complaintNum];
		
		ObjectProperty hasSymptomOf = mData.createObjectProperty(defaultNameSpace + "hassymptomof");
		ObjectProperty hasDegreeOf = mData.createObjectProperty(defaultNameSpace + "has_degree_of");
		DatatypeProperty hasDurationDay = mData.createDatatypeProperty(defaultNameSpace + "has_duration_day");
		
		for (int i = 0; i < complaintNum; ++i){
			complaint[i] = mData.createClass(defaultNameSpace + info.getComplaint()[i]);
			mData.add(ont, hasSymptomOf, complaint[i]);
			if (!info.getComplaintDegree()[i].equals("unselected")){
				mData.addLiteral(complaint[i], hasDegreeOf, info.getComplaintDegree()[i]);
			}
			if (!info.getComplaintTime()[i].equals("")){
				mData.addLiteral(complaint[i], hasDurationDay, info.getComplaintTime()[i]);
			}
		}
		
		int phyExamNum = info.getPhyExam().length;
		OntClass phyExam[] = new OntClass[phyExamNum];
		DatatypeProperty phyExamProperty[] = new DatatypeProperty[phyExamNum];
		for (int i = 0; i < phyExamNum; ++i){
			phyExam[i] = mData.createClass(defaultNameSpace + info.getPhyExam()[i]);
			phyExamProperty[i] = mData.createDatatypeProperty(defaultNameSpace + "has_test_" + info.getPhyExam()[i]);
			mData.addLiteral(ont, phyExamProperty[i], info.getPhyExamResult()[i]);
		}
		
		int testNum = info.getTest().length;
		OntClass test[] = new OntClass[testNum];
		DatatypeProperty testProperty[] = new DatatypeProperty[testNum];
		for (int i = 0; i < testNum; ++i){
			test[i] = mData.createClass(defaultNameSpace + info.getTest()[i]);
			testProperty[i] = mData.createDatatypeProperty(defaultNameSpace + "has_test_" + info.getTest()[i]);
			mData.addLiteral(ont, testProperty[i], info.getTestResult()[i]);
		}
		
		mytest(info);
	}
}