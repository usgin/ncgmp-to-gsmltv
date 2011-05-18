SELECT 	polys.mapunitpolys_id AS featureuri, 
	dmu.name AS name, 
	dmu.fullname AS fullname, 
	dmu.label AS label,
	'urn:ogc:def:nil:OGC:missing'::character varying AS parenturi,
	dmu.description AS description,
	dmu.areafillrgb AS symbol,
	dmu.descriptionofmapunits_id AS specificationuri,
	'urn:cgi:classifier:CGI:GeologicUnitType:200811:lithostratigraphic_unit'::character varying AS geologicunittype,
	preferredage.agedisplay AS geologichistory,
	CASE preferredage.agedisplayurn IS NULL
		WHEN true THEN preferredage.youngerurn
		ELSE preferredage.agedisplayurn
	END AS representativeageuri,
	preferredage.youngerurn AS youngerageuri,
	preferredage.olderurn AS olderageuri,
	dmu.hierarchykey AS rank,
	dmuext.lithology_summary AS lithology,
	ccl.cgiurn AS representativelithologyuri,
	'urn:ogc:def:nil:OGC:missing'::character varying AS observationmethod,
	polys.datasourceid AS sourceuri,
	polys.datasourceid AS metadatauri,
	polys.shape AS shape

FROM public.ncgmp_mapunitpolys AS polys 
JOIN public.ncgmp_descriptionofmapunits AS dmu on polys.mapunit = dmu.mapunit
JOIN public.ncgmp_datasources AS ds on polys.datasourceid = ds.datasources_id
JOIN usgin.geologicevent AS preferredage on dmu.descriptionofmapunits_id = preferredage.preferredage_dmu_id
LEFT JOIN public.ncgmp_ex_dmuextension AS dmuext on dmu.mapunit = dmuext.mapunit
LEFT JOIN usgin.controlledconceptlookup AS ccl on dmuext.representative_lithology = ccl.lookupterm