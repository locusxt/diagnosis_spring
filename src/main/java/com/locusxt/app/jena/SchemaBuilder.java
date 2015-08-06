package com.locusxt.app.jena;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

import com.hp.hpl.jena.ontology.OntClass;
import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.ontology.OntModelSpec;
import com.hp.hpl.jena.ontology.OntProperty;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.locusxt.app.domain.MyOntology;
import com.locusxt.app.domain.Ontschema;
import com.locusxt.app.domain.ZNodes;

class Node{
	String id;
	String name;
};

public class SchemaBuilder {
	public static String ns="http://somewhere/";
	public static OntModel modelschema;
	
	public void initBuild(){
		modelschema=ModelFactory.createOntologyModel(OntModelSpec.OWL_DL_MEM);
		OntClass disease=modelschema.createClass(ns+"disease");
		
		OntClass commoncold=modelschema.createClass(ns+"commoncold");
		OntClass fluza=modelschema.createClass(ns+"fluza");
		OntClass infection=modelschema.createClass(ns+"infection");
		
		OntClass purefluza=modelschema.createClass(ns+"purefluza");
		OntClass pneumoniafluza=modelschema.createClass(ns+"pneumoniafluza");
		OntClass poisonfluza=modelschema.createClass(ns+"poisonfluza");
		OntClass stomachfluza=modelschema.createClass(ns+"stomachfluza");
		
		OntClass virusesinfection=modelschema.createClass(ns+"virusesinfection");
		OntClass herpsinfection=modelschema.createClass(ns+"herpsinfection");
		OntClass pharyngeal_conjunctival_fever=modelschema.createClass(ns+"pharyngeal_conjunctival_fever");
		OntClass bacterial_pharyngitis=modelschema.createClass(ns+"bacterial_pharyngitis");
		
		disease.addSubClass(commoncold);
		disease.addSubClass(fluza);
		disease.addSubClass(infection);
		fluza.addSubClass(purefluza);
		fluza.addSubClass(pneumoniafluza);
		fluza.addSubClass(poisonfluza);
		fluza.addSubClass(stomachfluza);
		infection.addSubClass(virusesinfection);
		infection.addSubClass(herpsinfection);
		infection.addSubClass(pharyngeal_conjunctival_fever);
		infection.addSubClass(bacterial_pharyngitis);
		
		OntClass symptom=modelschema.createClass(ns+"sympotom");
		OntClass dry_throat=modelschema.createClass(ns+"dry_throat");
		OntClass sore_throat=modelschema.createClass(ns+"sore_throat");
		OntClass sneeze=modelschema.createClass(ns+"sneeze");
		OntClass fever=modelschema.createClass(ns+"fever");
		OntClass dizzy=modelschema.createClass(ns+"dizzy");
		OntClass headache=modelschema.createClass(ns+"headache");
		OntClass high_fever=modelschema.createClass(ns+"high_fever");
		OntClass unconscious=modelschema.createClass(ns+"unconscious");
		
		OntProperty hassymptomof=modelschema.createOntProperty(ns+"hassymptomof");
		OntProperty hassymptomof1=modelschema.createOntProperty(ns+"hassymptomof");
		OntProperty hastempertureof=modelschema.createOntProperty(ns+"hastempertureof");
		OntProperty duration=modelschema.createOntProperty(ns+"duration");
		
		
		modelschema.add(commoncold, hassymptomof, dry_throat);
		modelschema.add(commoncold, hassymptomof, sore_throat);
		modelschema.add(purefluza, hassymptomof, fever);
		modelschema.add(purefluza, hassymptomof, dizzy);
		modelschema.add(purefluza, hassymptomof, headache);
		modelschema.add(poisonfluza, hassymptomof, high_fever);
		modelschema.add(poisonfluza, hassymptomof1, unconscious);
		modelschema.write(System.out);
	}
	
	public static void main(String[] args){
		SchemaBuilder sb = new SchemaBuilder();
		sb.initBuild();
	}
	
	public void build(MyOntology onto){
		modelschema=ModelFactory.createOntologyModel(OntModelSpec.OWL_DL_MEM);
		Map <String, String> map = new HashMap<String, String>();//id, name
		Map <String, String> rmap = new HashMap<String, String>();//name, id
		Map <String, OntClass> omap = new HashMap<String, OntClass>();//id, ont
		
		ZNodes[] zNodes = onto.getZNodes();
		Ontschema[] ontschema = onto.getOntschema();
		
		int zNodesNum = zNodes.length;
		for (int i = 0; i < zNodesNum; ++i){
			map.put(zNodes[i].getId(), zNodes[i].getName());
			rmap.put(zNodes[i].getName(), zNodes[i].getId());
			OntClass ontClass = modelschema.createClass(ns + zNodes[i].getName());
			omap.put(zNodes[i].getId(), ontClass);
		}
		
		for (int i = 0; i < zNodesNum; ++i){
			String parentName = map.get(zNodes[i].getPId());
			if (parentName == null){
				continue;
			}
			OntClass parent = omap.get(zNodes[i].getPId());
			OntClass child = omap.get(zNodes[i].getId());
			parent.addSubClass(child);
		}
		
		int ontschemaNum = ontschema.length;
		for (int i = 0; i < ontschemaNum; ++i){
			OntProperty property = modelschema.createOntProperty(ns + ontschema[i].getProperty());
			OntClass subject = omap.get(rmap.get(ontschema[i].getSubject()));
			OntClass object = omap.get(rmap.get(ontschema[i].getObject()));
			modelschema.add(subject, property, object);
		}
		
		try {
			FileOutputStream out = new FileOutputStream(new File("a.xml"));
			modelschema.write(out);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		modelschema.write(System.out);

	}
	
//	public MyOntology getOntology(){
//		
//	}
}
