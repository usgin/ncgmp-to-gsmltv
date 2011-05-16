SELECT 	polys.mapunitpolys_id AS featureuri, 
	dmu.name AS name, 
	dmu.fullname AS fullname, 
	dmu.label AS label,
	'urn:ogc:def:nil:OGC:missing'::character varying AS parenturi,
	dmu.description AS description,
	dmu.areafillrgb AS symbol,
	dmu.descriptionofmapunits_id AS specificationuri,
	'LithostratigraphicUnit'::character varying AS geologicunittype, --need URI for this...
	preferredage.agedisplay AS geologichistory,
	CASE preferredage.agedisplayurn IS NULL
		WHEN true THEN preferredage.youngerurn
		ELSE preferredage.agedisplayurn
	END AS representativeageuri,
	preferredage.youngerurn AS youngerageuri,
	preferredage.olderurn AS olderageuri,
	dmu.hierarchykey AS rank,
	'term;proportion|term;proportion|...'::character varying AS lithology, --this might be all the standard lithology terms
	'dominanturi if that exists'::character varying AS representativelithologyuri, --this might be the dominant std lith
	'urn:ogc:def:nil:OGC:missing'::character varying AS observationmethod,
	polys.datasourceid AS sourceuri,
	polys.datasourceid AS metadatauri,
	polys.shape AS shape

FROM public.ncgmp_mapunitpolys AS polys 
JOIN public.ncgmp_descriptionofmapunits AS dmu on polys.mapunit = dmu.mapunit
JOIN public.ncgmp_datasources AS ds on polys.datasourceid = ds.datasources_id
JOIN usgin.geologicevent AS preferredage on dmu.descriptionofmapunits_id = preferredage.preferredage_dmu_id;